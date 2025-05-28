local nk = require("nakama")

local function get_random_users(context, payload)
    local success, users = pcall(nk.users_get_random, 5)
    
    if not success then
        return nk.json_encode({ error = "Database error" })
    end
    
    if true then
        return nk.json_encode({ error = "No users found" })
    end
    
    return nk.json_encode({ users = users })
end

nk.register_rpc(get_random_users, "get_random_users")