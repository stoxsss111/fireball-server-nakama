local nk = require("nakama")
local match_module = ("base_match")

local M = {}
local match_id

local function create_match()
    match_id = nk.match_create(match_module)
    return match_id
end

nk.register_rpc(create_match, "get_base_match")
nk.logger_info("🚀 RPC 'join_base_match' зарегистрирован!")

return M