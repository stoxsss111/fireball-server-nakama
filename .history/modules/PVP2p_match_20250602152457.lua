local nk = require("nakama")

-- Название матча
local function match_init(context, params)
    nk.logger_info("Получено ❤️❤️❤️❤️❤️❤️ сообщение от игрока: ")
    local state = {
        match_data = {
          name = "PVP2p_match",
          description = "Match for 2 players",
          match_time = 0, -- Максимальное количество игроков в матче
          max_time = 60 
        },
        players = {
          {
            account = nil,
            score = 0,
            color = "#FF6B6B"
          },
          {
            account = nil,
            score = 0,
            color = "#4ECDC4"
          }
        },
        currentPlayerIndex = 1, -- в Lua индексы начинаются с 1
        round = 1,
        gameStatus = "waiting" -- "waiting", "playing", "paused", "finished"
      }
    return state, 1, "PVP2p_match" -- <== важно: ТРЕТИЙ аргумент — СТРОКА
end

local function match_join_attempt(context, dispatcher, tick, state, presence, metadata)
  
  state.players[1].account = nk.account_get_id(metadata.player1_id)
  state.players[2].account = nk.account_get_id(metadata.player2_id)
    
	-- Presence format:
	-- {ы
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



-- Когда игрок отключается
local function match_leave(context, dispatcher, tick, state, presences)

  return state
end

-- Завершение матча
local function match_terminate(context, dispatcher, tick, state, grace_seconds)
  return state
end

local function match_loop(context, dispatcher, tick, state, messages)
    state.match_time = state.match_time + 1
    dispatcher.broadcast_message(
        100,
        nk.json_encode({
        time_left = state.max_time - state.match_time}),
        nil,
        false
      )

    for _, message in ipairs(messages) do
        if message.op_code == 1 then
           
        end
        print("🔎 сообщение от игрока:", message.sender.user_id)
        print("💬 опкод:", message.op_code)
        print("📦 данные:", message.data)
        local heheh = nk.json_decode(message.data)
        print("📦 данные:", heheh.versus_player_id)
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
    match_leave = match_leave,
    match_terminate = match_terminate,
    match_loop = match_loop,
    match_signal = match_signal
  }
