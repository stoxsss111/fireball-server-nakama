nk = require("nakama")

-- Регистрируем RPC-функцию в Nakama
local function get_random_users(context, payload)
    -- Получаем 5 случайных пользователей
    local users = nk.users_get_random(5)
    
    -- Проверяем, есть ли пользователи
    if #users == 0 then
        return nk.json_encode({ error = "No users found" })
    end
    
    -- Формируем результат
    local result = {}
    for _, user in ipairs(users) do
        table.insert(result, {
            user_id = user.user_id,
            username = user.username,
            location = user.location,     
            avatar_url = user.avatar_url
        })
    end
    
    -- Возвращаем результат в формате JSON
    return nk.json_encode(result)
end

-- Регистрируем функцию
nk.register_rpc(get_random_users, "get_random_users")