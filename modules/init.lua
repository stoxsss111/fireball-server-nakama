local nk = require("nakama")

local M = {}


function M.setup_account(context, payload)

    local data = nk.json_decode(payload)
    if not data then
        nk.logger_error("Не удалось декодировать payload!")
        return nk.json_encode({ success = false, error = "Invalid JSON" })
    end

    local meta = nk.json_encode(data)

    local player = {
        
    }

    local user_id = context.user_id
    local username = data.username
    local metadata = player
    local display_name = data.display_name
    local timezone = ""
    local location = data.location
    local language = "ENG"
    local avatar_url = data.avatar_url

    nk.logger_info(tostring(data.username) .. " has been set up.")

    -- Преобразуем таблицу в JSON-строку

    -- Обновляем аккаунт
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
    local metadata = {
        avatar_url = "",
        country = "CA",
        level = 1,
        score = 0
    }
    nk.account_update_id(user_id, nil, metadata)

    return {success = true}
end



nk.register_rpc(M.setup_account, "setup_account")
nk.register_rpc(M.delete_user_data, "delete_user_data")

return M