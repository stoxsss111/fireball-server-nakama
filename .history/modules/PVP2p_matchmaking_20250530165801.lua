local nk = require("nakama")
local match_module = "PVP2p_match"
local match_id

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

local function create_match()
    match_id = nk.match_create(match_module)
    return nk.json_encode({ match_id = match_id })
end

nk.register_rpc(get_random_users, "get_random_users")
nk.register_rpc(create_match, "create_pvp2p_match")