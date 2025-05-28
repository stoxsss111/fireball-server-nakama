nk = require("nakama")

-- Регистрируем RPC-функцию в Nakama
local function get_random_users(context, payload)
    local users = nk.users_get_random(5)

    if not users[1] then return nk.logger_error("❌ Users not fouund") end
    return nk.json_encode(users)
end

-- Регистрируем функцию
nk.register_rpc(get_random_users, "get_random_users")