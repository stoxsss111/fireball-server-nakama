local nk = require("nakama")

local M = {}


function M.setup_account(context, payload)

    local data = nk.json_decode(payload)
    if not data then
        nk.logger_error("Не удалось декодировать payload!")
        return nk.json_encode({ success = false, error = "Invalid JSON" })
    end

local user_id = context.user_id
local username = data.username
local avatar_url = data.avatar_url
local user_country = data.country or "US"
local display_name = data.displayName or "hero"

nk.logger_info(tostring(data.username) .. " has been set up.")

-- Собираем метаданные
local data = {
    avatar_url = avatar_url,
    country = user_country,
    level = 1,
    score = 0
}

-- Преобразуем таблицу в JSON-строку
local metadata = nk.json_encode(data)

-- Обновляем аккаунт
nk.account_update_id(
    user_id,
    data,-- Идентификатор пользователя
    username,         -- Новый никнейм
    display_name -- Метаданные в виде строки JSON
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
            country = "",
            level = 1,
            score = 0
    }
    nk.account_update_id(user_id, nil, metadata)
    
    return {success = true}
end




nk.register_rpc(M.setup_account, "setup_account")
nk.register_rpc(M.delete_user_data, "delete_user_data")

return M