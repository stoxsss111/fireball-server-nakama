local nk = require("nakama")
local match_module = ("base_match")

local M = {}
local match = {}

function M.create_match()

    local params = {}
   
    match.match_id = nk.match_create(match_module, params)
    
end

M.create_match()


function M.get_match_id()
    return nk.json_encode(match)
end

nk.register_rpc(M.get_match_id, "get_match_id")
nk.logger_info("🚀 RPC 'get_match_id' зарегистрирован!")

return M