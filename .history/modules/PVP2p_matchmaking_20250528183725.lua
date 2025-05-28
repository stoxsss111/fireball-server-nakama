nk = require("nakama")

-- Регистрируем RPC-функцию в Nakama
local function get_random_users(context, payload)
    local users = nk.users_get_random(5)


    return nk.json_encode(users)
end

-- Регистрируем функцию
nk.register_rpc(get_random_users, "get_random_users")