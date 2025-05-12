local nk = require("nakama")

local function match_init(context, params)

    local state = {}

    return state, 1, "base_match" 
end

local function match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    nk.logger_info("Игрокиииииииииииииии тут📦")
    -- Presence format:
    -- {
    --   user_id = "user unique ID",
    --   session_id = "session ID of the user's current connection",
    --   username = "user's unique username",
    --   node = "name of the Nakama node the user is connected to"
    -- }

    return state, true
end


local function match_join(context, dispatcher, tick, state, presences)
    nk.logger_info("Игрокиииииииииииииии тут📦" .. #presences)
    return state
end


local function match_receive(context, dispatcher, tick, state, presence, op_code, data)

    return state
end


local function match_tick(context, dispatcher, tick, state, messages)
   
    state.tick = tick
    return state
end


local function match_leave(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        nk.logger_info("🔎Игрок удалился".. presence.user_id)
    end
    return state
end


local function match_terminate(context, dispatcher, tick, state, grace_seconds)
    return state
end

local function match_loop(context, dispatcher, tick, state, messages)
    --nk.logger_info("Игрокиииииииииииииии тут📦")
    
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
