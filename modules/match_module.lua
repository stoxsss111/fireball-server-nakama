local nk = require("nakama")

-- Название матча
local function match_init(context, params)
    local now = os.time()
    local state = {
        start_time = params.start_time or now,
        end_time = (params.start_time or now) + (params.duration or 600),
        teams = {
            {players = {}, score = 0},
            {players = {}, score = 0}
        },
        players = {},
        bots = {},
        messages = {},
        match_params = params
    }

    return state, 1, "basic_match" -- <== важно: ТРЕТИЙ аргумент — СТРОКА
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
