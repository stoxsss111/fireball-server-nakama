local nk = require("nakama")

-- 🔧 MinIO Settings
local MINIO_ENDPOINT = "minio:9000"
local MINIO_BUCKET = "nakama-storage"
local MINIO_ACCESS_KEY = "DlQ2uh1KmrkSXoXoGWmG"
local MINIO_SECRET_KEY = "Y6B2r9z0P1aK4RY5J4HisDY8yXMQR9x3kPotyfzO"

-- 🪣 Function to check bucket existence
local function check_bucket()
    nk.logger_info("🔎 Проверка бакета MinIO: " .. MINIO_BUCKET)

    -- URL with query parameters for authentication (testing only)
    local url = string.format("http://%s/%s?accessKey=%s&secretKey=%s", MINIO_ENDPOINT, MINIO_BUCKET, MINIO_ACCESS_KEY, MINIO_SECRET_KEY)
    local method = "HEAD"
    local body = ""
    local headers = {
        ["Host"] = MINIO_ENDPOINT
    }

    nk.logger_info("📡 Отправка запроса: " .. method .. " " .. url)
    local success, response = pcall(nk.http_request, url, method, headers, body)

    if success then
        nk.logger_info("📬 Ответ получен, код: " .. tostring(response))
        if response == 200 then
            nk.logger_info("✅ Бакет существует: " .. MINIO_BUCKET)
        else
            nk.logger_error("❌ Бакет не найден или ошибка: код " .. tostring(response))
        end
    else
        nk.logger_error("💥 Ошибка HTTP: " .. tostring(response))
    end
end

-- 🚀 Run
local success, err = pcall(check_bucket)
if not success then
    nk.logger_error("💥 Ошибка выполнения check_bucket: " .. tostring(err))
end