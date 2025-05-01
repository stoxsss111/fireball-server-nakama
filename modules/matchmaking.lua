local nk = require("nakama")
local match_module = ("match_module")



local M = {}

-- Вспомогательная функция: создаёт матч и возвращает match_id
function M.create_match()
    local params = {
        start_time = os.time(),
        max_players = 20,
        team_size = 10,
        duration = 600,
        min_players = 2
    }

    local match_id = nk.match_create(match_module, params)
    return match_id
end

-- RPC-функция для поиска или создания матча
function M.find_match(context, payload)
    local user_id = context.user_id
    if not user_id then
        error("User not authenticated")
    end

    local current_time = os.time()

    -- Поиск активных матчей
    local matches = nk.match_list(10, true, nil, 1, nil, nil)
    local suitable_match = nil

    for _, match in ipairs(matches) do
        local age_ok = match.create_time and ((current_time - match.create_time) <= 60)
        local has_space = match.size and match.max_size and (match.size < match.max_size)

        if age_ok and has_space then
            suitable_match = match
            break
        end
    end

    local result = {}

    if suitable_match then
        result.match_id = suitable_match.match_id
        result.is_new = false
    else
        result.match_id = M.create_match()
        result.is_new = true
    end

    return nk.json_encode(result)
end

nk.register_rpc(M.find_match, "find_match")

return M



