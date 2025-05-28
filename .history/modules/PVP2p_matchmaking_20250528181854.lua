local nk = require("nakama")

local function get_random_users(context, payload)
    local response = { nk.json_encode({error = nil, users = {}}) }
    
    local success, users = pcall(nk.users_get_random, 5)
    
    if success then
        response.error = "Database error"
    elseif #users == 0 then
        response.error = "No users found"
    else
        response.users = users
    end
    
    return nk.json_encode(response)
end

nk.register_rpc(get_random_users, "get_random_users")