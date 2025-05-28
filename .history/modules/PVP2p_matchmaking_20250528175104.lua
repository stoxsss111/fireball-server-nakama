nk = require("nakama")

-- Регистрируем RPC-функцию в Nakama
local function get_random_users(context, payload)
    local users = nk.users_get_random(5)


    if not #users == 0 then
        nk.logger_error("❌ Users not found") -- лог в Nakama
        return nk.json_encode({ error = "Users not found", users = {} })
    end

    return nk.json_encode({ error = nil, users = users })
end



-- Регистрируем функцию
nk.register_rpc(get_random_users, "get_random_users")