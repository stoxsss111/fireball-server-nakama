local nk = require("nakama")
local match_module = ("base_match")

local M = {}
local match_id

function M.create_match()

    local params = {
        start_time = os.time(),
        max_players = 20,
        team_size = 10,
        duration = 600,
        min_players = 10,
        player_join_time = 60
    }


    nk.logger_info("🛠️ Создание нового матча с параметрами: " .. nk.json_encode(params))
    match_id = nk.match_create(match_module, params)
    nk.logger_info("✅ Матч создан! match_id: " .. match_id .. " 🎉")
    return match_id
end


function M.get_match_id()
    return match_id
end

nk.register_rpc(M.get_match_id, "get_base_match")
nk.logger_info("🚀 RPC 'join_base_match' зарегистрирован!")

return M