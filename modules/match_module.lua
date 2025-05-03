local nk = require("nakama")



-- Название матча
local function match_init(context, params)
    local now = os.time()

local is_private = false  -- или получить значение из другого источника
local player_count = 0    -- или получить значение из другого источника
local required_player_count = 2  -- или получить значение из другого источника

local label = nk.json_encode({ 
    isPrivate = is_private, 
    playerCount = player_count, 
    requiredPlayerCount = required_player_count 
})

    local state = {
        start_time = params.start_time or now,
        duration = params.duration,
        teams = {
            {players = {}, score = 0},
            {players = {}, score = 0}
        },
        players = {},
        players_count = 0,
        bots = {},
        messages = {},
        player_join_time = max_time_to_add,
        match_params = params,
        is_private = true, 
        player_count = 0,
        required_player_count = 2   
    }

    return state, 1, label -- <== важно: ТРЕТИЙ аргумент — СТРОКА
end

local function match_join_attempt(context, dispatcher, tick, state, presence, metadata)
	-- Presence format:
	-- {
	--   user_id = "user unique ID",
	--   session_id = "session ID of the user's current connection",
	--   username = "user's unique username",
	--   node = "name of the Nakama node the user is connected to"
	-- }
  
	return state, true
  end

-- Подтверждение входа игрока
local function match_join(context, dispatcher, tick, state, presences)
  nk.logger_info("Игрок тут📦" .. #presences)
    return state
end

-- Обработка сообщений от клиентов
local function match_receive(context, dispatcher, tick, state, presence, op_code, data)
  
  return state
end

-- Обработка тиков
local function match_tick(context, dispatcher, tick, state, messages)
  state.tick = tick
  return state
end

-- Когда игрок отключается
local function match_leave(context, dispatcher, tick, state, presences)
 
  return state
end

-- Завершение матча
local function match_terminate(context, dispatcher, tick, state, grace_seconds)
  return state
end

local function match_loop(context, dispatcher, tick, state, messages)
  
  
  local elapsed_time = os.time() - state.start_time

  local TickData = {
    total_seconds = state.duration,
    elapsed_seconds = elapsed_time
  }

  dispatcher.broadcast_message(1, nk.json_encode(TickData), nil, nil)

  --[Длительность матча]
    if elapsed_time >= state.duration then
        return nil  -- Завершаем матч
    end
    return state
end

  local function match_signal(context, dispatcher, tick, state, data)
 
    return state
  end


return {
    match_init = match_init,
    match_join_attempt = match_join_attempt,
    match_join = match_join,
    match_receive = match_receive,
    match_tick = match_tick,
    match_leave = match_leave,
    match_terminate = match_terminate,
    match_loop = match_loop,
    match_signal = match_signal
  }
