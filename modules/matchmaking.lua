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
        min_players = 10,
        player_join_time = 60
    }

    params.label = nk.json_encode(label_data)

    nk.logger_info("🛠️ Создание нового матча с параметрами: " .. nk.json_encode(params))
    local match_id = nk.match_create(match_module, params)
    nk.logger_info("✅ Матч создан! match_id: " .. match_id .. " 🎉")
    return match_id
end

-- RPC-функция для поиска или создания матча
function M.find_match(context, payload)
    local user_id = context.user_id
    nk.logger_info("📞 RPC вызов 'find_match' от пользователя: " .. (user_id or "nil"))

    if not user_id then
        nk.logger_error("🚫 Ошибка: пользователь не аутентифицирован ❌")
        error("User not authenticated")
    end

    local current_time = os.time()
    nk.logger_info("⏰ Текущее время: " .. current_time)

    -- Поиск активных матчей
    nk.logger_info("🔍 Поиск активных матчей...")
    local matches = nk.match_list(10, true, nil, 1, nil, nil)
    nk.logger_info("📋 Найдено матчей: " .. tostring(#matches))

    local suitable_match = nil

    for _, match in ipairs(matches) do
        nk.logger_info("🧪 Проверка матча: " .. nk.json_encode(match))
        local age_ok = match.start_time and ((current_time - match.start_time) <= match.player_join_time)
        local label = nk.json_decode(match.label)
    
    -- Корректный вывод значения isPrivate
    nk.logger_info("🧪Возраст матча подходит: " .. tostring(label.isPrivate))
        
        local has_space = match.size and match.max_size and (match.size < match.max_size)
        nk.logger_info("🧪В матче есть место: " .. tostring(match.max_size))

        if age_ok and has_space then
            suitable_match = match
            nk.logger_info("🎯 Подходящий матч найден! match_id: " .. match.match_id)
            break
        end
    end

    local result = {}

    if suitable_match then
        result.match_id = suitable_match.match_id
        result.is_new = false
        nk.logger_info("🤝 Присоединяемся к существующему матчу: " .. result.match_id)
    else
        result.match_id = M.create_match()
        result.is_new = true
        nk.logger_info("🌟 Не найдено подходящих матчей. Создан новый: " .. result.match_id)
    end

    return nk.json_encode(result)
end

nk.register_rpc(M.find_match, "find_match")
nk.logger_info("🚀 RPC 'find_match' зарегистрирован!")

return M