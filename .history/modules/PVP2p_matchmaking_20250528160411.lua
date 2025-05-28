nk = require("nakama")

-- Регистрируем RPC-функцию в Nakama
local function get_random_users(context, payload)
    local users = nk.users_get_random(5)
    
    if #users == 0 then
        return nk.json_encode({ error = "No users found" })
    end
    
    local result = {}

    for _, user in ipairs(users) do
        -- Получаем аккаунт, чтобы достать metadata
        local account = nk.account_get_id(user.user_id)

        table.insert(result, {
            user_id = user.user_id,
            username = user.username,
            location = user.location,
            avatar_url = user.avatar_url,
            is_bot = account.metadata.is_bot  -- вот оно!
        })
    end

    return nk.json_encode(result)
end

-- Регистрируем функцию
nk.register_rpc(get_random_users, "get_random_users")