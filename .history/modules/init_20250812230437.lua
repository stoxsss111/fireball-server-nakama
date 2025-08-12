local nk = require("nakama")

local M = {}


function M.setup_account(context, payload)
    local data = nk.json_decode(payload)
    if not data then
        nk.logger_error("Не удалось декодировать payload!")
        return nk.json_encode({ success = false, error = "Invalid JSON" })
    end

    local meta = { is_bot = false }
 
    local user_id = context.user_id
    local metadata = meta
    local username = data.username
    local display_name = data.display_name
    local timezone = ""
    local location = data.location
    local language = "ENG"
    local avatar_url = data.avatar_url

    nk.logger_info(tostring(username) .. " has been set up.")

    local ok, err = pcall(function()
        nk.account_update_id(
            user_id,
            metadata,
            username,
            display_name,
            timezone,
            location,
            language,
            avatar_url
        )
    end)

    if not ok then
        nk.logger_error("Ошибка обновления аккаунта: " .. tostring(err))
        return nk.json_encode({ success = false, error = tostring(err) })
    end

    return nk.json_encode({ success = true, message = "Account created successfully" })
end


-- Удаление данных пользователя
function M.delete_user_data(context, payload)
    local user_id = context.user_id

    if not user_id then
        error("User not authenticated")
    end

    -- Удаление статистики
    local objects = nk.storage_list(user_id, "stats", 100)
    for _, object in ipairs(objects) do
        nk.storage_delete(user_id, "stats", object.key)
    end

    -- Удаление аватара
    nk.storage_delete(user_id, "avatars", "avatar")

    -- Удаление настроек
    nk.storage_delete(user_id, "settings", "user_settings")

    -- Сброс метаданных аккаунта
    local metadata_to_change = {
        avatar_url = "",
        country = "CA",
        level = 1,
        score = 0
    }
    nk.account_update_id(user_id, nil, metadata_to_change)

    return {success = true}
end

function M.check_nickname(context, payload)
    local data = nk.json_decode(payload)
    if not data or not data.nickname or data.nickname == "" then
        return nil, "Nickname not provided", 3  -- INVALID_ARGUMENT
    end

    local nickname = data.nickname

    local success, users = pcall(nk.users_get_by_display_name, nickname)

    if not success then
        nk.logger_error("Error in users_get_by_display_name: " .. tostring(users))
        return nil, "Internal server error", 13  -- INTERNAL
    end

    if users and #users > 0 then
        return nk.json_encode({ is_unique = false }), nil
    else
        return nk.json_encode({ is_unique = true }), nil
    end
end


-- Регистрируем RPC по имени "check_nickname"
nk.register_rpc(M.check_nickname, "check_nickname")
nk.register_rpc(M.setup_account, "setup_account")
nk.register_rpc(M.delete_user_data, "delete_user_data")

return M