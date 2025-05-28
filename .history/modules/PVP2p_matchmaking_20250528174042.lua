nk = require("nakama")

-- Регистрируем RPC-функцию в Nakama
local function get_random_users(context, payload)
    local users = nk.users_get_random(5)

    if  users[1] then
        nk.logger_warn("⚠️ Не найдено ни одного пользователя.")
        return nk.json_encode({
            error = "Users not found",
            users = {}
        })
    end

    return nk.json_encode({
        error = nil,
        users = users
    })
end




-- Регистрируем функцию
nk.register_rpc(get_random_users, "get_random_users")