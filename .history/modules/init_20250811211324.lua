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
    -- 1. Декодируем входящие данные
    local data = nk.json_decode(payload)
    if data == nil or data.nickname == nil or data.nickname == "" then
        -- Возвращаем ошибку, если никнейм не предоставлен
        return nk.json_encode({error = "Nickname not provided"}), 400
    end

    local nickname = data.nickname

    -- 2. Безопасно вызываем функцию Nakama с помощью pcall
    -- success будет true/false, result будет либо таблицей пользователей, либо сообщением об ошибке
    local success, result = pcall(nk.users_get_by_display_name, nickname)

    -- 3. Обрабатываем результат вызова
    if not success then
        -- Если pcall вернул false, значит произошла внутренняя ошибка (например, с БД)
        nk.logger_error("Error in users_get_by_display_name: " .. tostring(result))
        -- Возвращаем клиенту общую ошибку сервера
        return nk.json_encode({error = "Internal server error"}), 500
    end

    -- На этом этапе success равен true, а result содержит ответ от nk.users_get_by_display_name
    -- (который может быть таблицей пользователей или nil/пустой таблицей, если никто не найден)
    local users = result

    -- 4. Проверяем, найдены ли пользователи
    if users and #users > 0 then
        -- Если массив users не пустой, никнейм занят
        return nk.json_encode({ is_unique = false })
    else
        -- Если users это nil или пустая таблица, никнейм свободен
        return nk.json_encode({ is_unique = true })
    end
end


-- Регистрируем RPC по имени "check_nickname"
nk.register_rpc(M.check_nickname, "check_nickname")
nk.register_rpc(M.setup_account, "setup_account")
nk.register_rpc(M.delete_user_data, "delete_user_data")

return M