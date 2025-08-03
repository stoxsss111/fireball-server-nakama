local nk = require("nakama")

-- Определяем опкоды для сетевых сообщений
local EOpCode = {
    RequestOnlineCount = 11,
    OnlineCount = 22,
}

-- Инициализация матча
local function match_init(context, params)
    -- Состояние матча теперь содержит только список игроков
    local state = {
        players = {}
    }

    nk.logger_info("🎮 Матч инициализирован. Игроков: 0")

    -- Возвращаем начальное состояние, тикрейт и название
    return state, 1, "base_match"
end

-- Попытка присоединения игрока
local function match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    -- Просто логгируем попытку, счетчик больше не нужен
    nk.logger_info("➕ Попытка входа от игрока: " .. presence.user_id)
    
    -- Разрешаем вход
    return state, true
end

-- Успешное присоединение игроков
local function match_join(context, dispatcher, tick, state, presences)
    -- Добавляем каждого нового игрока в таблицу state.players
    for _, p in ipairs(presences) do
        table.insert(state.players, p)
        nk.logger_info("👍 Игрок " .. p.user_id .. " успешно вошел.")
    end
    
    -- Логгируем актуальное количество игроков в матче
    nk.logger_info("👥 Игроков в матче: " .. tostring(#state.players))

    -- Закомментированный код для работы с лидербордами и хранилищем оставлен без изменений
    -- for _, presence in ipairs(presences) do
    --     ...
    -- end
    
    return state
end

-- Основной цикл матча
local function match_loop(context, dispatcher, tick, state, messages)
    -- Обрабатываем входящие сообщения от клиентов
    for _, message in ipairs(messages) do
        local op_code = message.op_code
        local sender = message.sender

        -- Если получен запрос на количество онлайн-игроков
        if op_code == EOpCode.RequestOnlineCount then
            nk.logger_info("📥 Получен запрос на онлайн от игрока: " .. sender.user_id)

            -- Получаем количество игроков напрямую из размера таблицы state.players
            local online_count = #state.players
            nk.logger_info("📊 Текущий онлайн: " .. online_count)

            -- Отправляем ответ только тому, кто запросил
            dispatcher.broadcast_message(EOpCode.OnlineCount, nk.json_encode({count = online_count}), {sender})

            nk.logger_info("📤 Отправлен онлайн (" .. tostring(online_count) .. ") игроку " .. sender.user_id)
        end
    end

    return state
end

-- Выход игроков из матча
local function match_leave(context, dispatcher, tick, state, presences)
    -- Создаем временную таблицу для быстрого поиска выходящих игроков
    local leaving_user_ids = {}
    for _, p in ipairs(presences) do
        leaving_user_ids[p.user_id] = true
        nk.logger_info("👋 Игрок " .. p.user_id .. " покидает матч.")
    end

    -- Создаем новый список игроков, исключая тех, кто вышел
    local remaining_players = {}
    for _, p in ipairs(state.players) do
        if not leaving_user_ids[p.user_id] then
            table.insert(remaining_players, p)
        end
    end
    
    -- Обновляем основной список игроков
    state.players = remaining_players
    
    -- Логгируем итоговое количество игроков
    nk.logger_info("👥 Игроков в матче после выхода: " .. tostring(#state.players))

    -- Закомментированный код для работы с лидербордами и хранилищем оставлен без изменений
    -- for _, presence in ipairs(presences) do
    --     ...
    -- end

    return state
end

-- Завершение матча
local function match_terminate(context, dispatcher, tick, state, grace_seconds)
    nk.logger_info("🛑 Матч завершается.")
    return state
end

-- Сигналы матча (для обработки внешних событий)
local function match_signal(context, dispatcher, tick, state, data)
    return state
end

-- Регистрация функций обратного вызова для Nakama
return {
    match_init = match_init,
    match_join_attempt = match_join_attempt,
    match_join = match_join,
    match_leave = match_leave,
    match_terminate = match_terminate,
    match_loop = match_loop,
    match_signal = match_signal
}