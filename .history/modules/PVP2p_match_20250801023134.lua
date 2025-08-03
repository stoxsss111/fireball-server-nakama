local nk = require("nakama")

EOpCode = {
    TimeLeft = 1,
    Player1Score = 10,
    Player2Score = 20,
    Player1Fire = 30,
    Player2Fire = 40,
    Pvp2PMatchEnd = 100
}

-- Название матча
local function match_init(context, params)
    nk.logger_info("Получено ❤️❤️❤️❤️❤️❤️ сообщение от игрока: ")
    local state = {
        match_data = {
          name = "PVP2p_match",
          description = "Match for 2 players",
          match_time = 0, -- Максимальное количество игроков в матче
          max_time = 60,
          finished = false
        },
        players = {
          {
            account = nil,
            fire = 0,
            score = 0,
            color = "#FF6B6B"
          },
          {
            account = nil,
            fire = 0,
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
  nk.logger_info("🏁 Мы покидаем матч!")
  return state
end


local function match_loop(context, dispatcher, tick, state, messages)

  for _, message in ipairs(messages) do
        local op_code = message.op_code
        local sender = message.sender
        local data = message.data

        if op_code == EOpCode.Player1Score then
            local decoded = nk.json_decode(data)
            state.players[1].score = decoded.Player1Score
        end

        if op_code == EOpCode.Player2Score then
            local decoded = nk.json_decode(data)
            state.players[2].score = decoded.Player2Score
        end

        if op_code == EOpCode.Player1Fire then
            local decoded = nk.json_decode(data)
            state.players[1].score = decoded.Player2Score
        end

    end

    local time_left = state.match_data.max_time - state.match_data.match_time

    if time_left >= 0 then
        dispatcher.broadcast_message(EOpCode.TimeLeft, nk.json_encode({time_left = time_left}), nil, nil)
        state.match_data.match_time = state.match_data.match_time + 1
        return state
      else
        dispatcher.broadcast_message(EOpCode.Pvp2PMatchEnd, nk.json_encode({time_left = time_left}), nil, nil)
        dispatcher.match_kick(state.presences)
        return nil -- Завершаем матч, если время вышло
    end


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
