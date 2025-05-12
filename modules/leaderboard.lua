local nk = require("nakama")

local M = {}




    function M.CreateLeaderboard()
        local id = "hour_active"
        local authoritative = false
        local sort = "desc"
        local operator = "incr"
        local reset = nil
        local metadata = {
            weather_conditions = "rain"
        }
        nk.leaderboard_create(id, authoritative, sort, operator, reset, metadata)
        
      
    end

    M.CreateLeaderboard()
   

    function M.DecayInactiveScores()
        local leaderboard_id = "hour_active"
        local now = os.time()
        local one_hour = 60 * 60
        local limit = 10000
        local cursor = nil
        

        repeat
            local result = nk.leaderboard_records_list(leaderboard_id, {}, limit, cursor)
            local records = result.records
            cursor = result.next_cursor

            local user_ids = {}
            for _, record in ipairs(records) do
                table.insert(user_ids, record.owner_id)
            end

            -- читаем last_active
            local reads = {}
            for _, user_id in ipairs(user_ids) do
                table.insert(reads, {
                    collection = "activity",
                    key = "last_active",
                    user_id = user_id
                })
            end

            local storage_data = nk.storage_read(reads)
            local last_active_map = {}
            for _, item in ipairs(storage_data) do
                last_active_map[item.user_id] = item.value.ts
            end

            for _, record in ipairs(records) do
                local user_id = record.owner_id
                local score = record.score or 0
                local last_active = last_active_map[user_id] or 0
                local time_since_active = now - last_active

                if time_since_active >= one_hour and score > 0 then
                    local new_score = score - 1
                    nk.leaderboard_submit(leaderboard_id, user_id, tostring(new_score))
                    print("📉 -1 очко (неактивен) у " .. user_id .. " → " .. new_score)
                else
                    print("✅ Активный или очки = 0: " .. user_id)
                end
            end

        until (not cursor or cursor == "")
    end



return M

