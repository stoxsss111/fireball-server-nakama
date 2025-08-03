local nk = require("nakama")

local function match_init(context, params)

    local state = {}

    return state, 1, "base_match" 
end

local function match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    nk.logger_info("Игрокиииииииииииииии тут📦")

    return state, true
end


local function match_join(context, dispatcher, tick, state, presences)
    -- for _, presence in ipairs(presences) do
    --     local result = nk.storage_read({
    --         {
    --             collection = "active_leaderboard_backup",
    --             key = "player_data",
    --             user_id = presence.user_id, 
    --         }
    --     })
        
    --     if result and #result > 0 then
    --         for i, entry in ipairs(result) do
    --             nk.logger_info("🔍 Резервная запись #" .. i)
    --             nk.logger_info("🆔 key: " .. entry.key)
    --             nk.logger_info("📚 collection: " .. entry.collection)
    --             nk.logger_info("👤 user_id: " .. entry.user_id)
    --             nk.logger_info("📦 value: " .. nk.json_encode(entry.value))

    --             nk.leaderboard_record_write({
    --                 leaderboard_id = "hour_active",
    --                 owner_id = entry.user_id,
    --                 score = entry.value.score
    --             })
    --         end
    --     else
    --         nk.logger_info("⚠️ Нет данных в резервной копии для игрока: " .. presence.user_id)
    --     end
    -- end

    
    return state
end

local function match_loop(context, dispatcher, tick, state, messages)
    return state
end


local function match_leave(context, dispatcher, tick, state, presences)
    -- for _, presence in ipairs(presences) do
    --     nk.logger_info("👋 Игрок покидает матч: " .. presence.user_id)

    --     nk.logger_info("🔎 Ищем рекорд в лидерборде для пользователя: " .. presence.user_id)
    --     local result = nk.leaderboard_records_list("hour_active", {presence.user_id}, 1, nil)
    --     nk.logger_info("🧪 result (leaderboard_records_list): " .. nk.json_encode(result))

    --     local record

    --     if result and #result > 0 then
    --         record = result[1]
    --         nk.logger_info("✅ Рекорд найден:")
    --         nk.logger_info("🏅 user_id: " .. record.owner_id)
    --         nk.logger_info("🏷️ username: " .. record.username)
    --         nk.logger_info("📊 score: " .. record.score)
    --         nk.logger_info("🥇 rank: " .. record.rank)
    --         nk.logger_info("📦 metadata: " .. nk.json_encode(record.metadata))
    --     else
    --         nk.logger_info("⚠️ Рекорд не найден, сохраняем пустую запись в backup.")
    --         record = {} -- или nil, если так логичнее
    --     end

    --     nk.logger_info("💾 Сохраняем резервную копию в хранилище...")
    --     nk.storage_write({
    --         {
    --             collection = "active_leaderboard_backup",
    --             key = "player_data",
    --             user_id = presence.user_id, -- 👈 здесь тоже лучше presence.user_id
    --             value = record
    --         }
    --     })

    --     nk.logger_info("🗑️ Удаляем игрока из лидерборда: " .. presence.user_id)
    --     nk.leaderboard_record_delete("hour_active", presence.user_id)
    -- end

    return state
end


local function match_terminate(context, dispatcher, tick, state, grace_seconds)
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
