local nk = require("nakama")

local function get_random_users(context, payload)
    local success, users = pcall(nk.users_get_random, 5)
    
    if not success then
        local error_message = "Database error"
        nk.logger_info(error_message);
        return nk.json_encode({ error = error_message })
    end
    
    if #users == 0 then
        local error_message = "No users found"
        nk.logger_info(error_message);
        return nk.json_encode({ error = error_message })
    end
    
    return nk.json_encode({ users = users })
end

nk.register_rpc(get_random_users, "get_random_users")