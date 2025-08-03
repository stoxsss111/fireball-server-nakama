local nk = require("nakama")
local match_module = ("base_match")

local M = {}
local match_id

local cached_match_id = nil

local function create_match()
    if cached_match_id ~= nil then
        nk.logger_info("⚠️ Матч уже создан: " .. cached_match_id)
        return cached_match_id
    end

    local new_match_id = nk.match_create(match_module)
    cached_match_id = new_match_id
    nk.logger_info("✅ Новый матч создан: " .. new_match_id)
    return new_match_id
end

nk.register_rpc(create_match, "get_base_match")
nk.logger_info("🚀 RPC 'get_base_match' зарегистрирован!")


return M