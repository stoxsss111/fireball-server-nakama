-- RPC и регистрация функций
nk.register_rpc(id, func) -- Регистрирует функцию как RPC вызов
nk.register_before(message_type, func) -- Регистрирует функцию, которая выполняется перед обработкой сообщения
nk.register_after(message_type, func) -- Регистрирует функцию, которая выполняется после обработки сообщения
nk.register_rt_before(message_type, func) -- Регистрирует функцию, выполняемую перед обработкой realtime сообщения
nk.register_rt_after(message_type, func) -- Регистрирует функцию, выполняемую после обработки realtime сообщения
nk.register_match_handler(module, params) -- Регистрирует обработчик матчей
nk.register_tournament_end(func) -- Регистрирует обработчик окончания турнира
nk.register_tournament_reset(func) -- Регистрирует обработчик сброса турнира
nk.register_leaderboard_reset(func) -- Регистрирует обработчик сброса лидерборда

-- Учетные записи пользователей
nk.authenticate_custom(id, username, create, vars) -- Аутентификация пользователя с помощью кастомного ID
nk.authenticate_device(id, username, create, vars) -- Аутентификация по ID устройства
nk.authenticate_email(email, password, username, create, vars) -- Аутентификация по email
nk.authenticate_facebook(token, import, username, create, vars) -- Аутентификация через Facebook
nk.authenticate_google(token, username, create, vars) -- Аутентификация через Google
nk.authenticate_gamecenter(player_id, bundle_id, timestamp, salt, signature, public_key_url, username, create, vars) -- Аутентификация через GameCenter
nk.authenticate_steam(token, username, create, vars) -- Аутентификация через Steam
nk.authenticate_token(token, vars) -- Аутентификация по токену
nk.account_get_id(user_id) -- Получение данных учетной записи по ID
nk.account_update_id(user_id, metadata, username, display_name, timezone, location, lang_tag, avatar_url, facebook_id, google_id, gamecenter_id, steam_id, custom_id, email, password) -- Обновление аккаунта
nk.accounts_get_id(user_ids) -- Получение множества аккаунтов по ID
nk.link_custom(user_id, custom_id) -- Привязка аккаунта к кастомному ID
nk.link_device(user_id, device_id) -- Привязка аккаунта к устройству
nk.link_email(user_id, email, password) -- Привязка email к аккаунту
nk.link_facebook(user_id, token, import) -- Привязка Facebook к аккаунту
nk.link_google(user_id, token) -- Привязка Google к аккаунту
nk.link_gamecenter(user_id, player_id, bundle_id, timestamp, salt, signature, public_key_url) -- Привязка GameCenter к аккаунту
nk.link_steam(user_id, token) -- Привязка Steam к аккаунту
nk.unlink_custom(user_id, custom_id) -- Отвязка кастомного ID от аккаунта
nk.unlink_device(user_id, device_id) -- Отвязка устройства от аккаунта
nk.unlink_email(user_id, email) -- Отвязка email от аккаунта
nk.unlink_facebook(user_id, token) -- Отвязка Facebook от аккаунта
nk.unlink_google(user_id, token) -- Отвязка Google от аккаунта
nk.unlink_gamecenter(user_id, player_id, bundle_id, timestamp, salt, signature, public_key_url) -- Отвязка GameCenter от аккаунта
nk.unlink_steam(user_id, token) -- Отвязка Steam от аккаунта

-- Хранение данных
nk.storage_write(collection, key, user_id, value, permission_read, permission_write, version) -- Запись данных в хранилище
nk.storage_read(collection, key, user_id) -- Чтение данных из хранилища
nk.storage_delete(collection, key, user_id) -- Удаление данных из хранилища
nk.storage_list(collection, user_id, limit, cursor) -- Список данных из хранилища
nk.storage_read_users(collection, key, user_ids) -- Чтение данных нескольких пользователей

-- Друзья и группы
nk.friends_list(user_id, limit, state, cursor) -- Список друзей
nk.friends_add(user_id, username, ids, usernames) -- Добавление друзей
nk.friends_delete(user_id, user_ids) -- Удаление друзей
nk.friends_block(user_id, user_ids) -- Блокировка пользователей
nk.group_create(user_id, name, description, lang_tag, metadata, avatar_url, open, max_count) -- Создание группы
nk.group_update(group_id, name, description, lang_tag, metadata, avatar_url, open, max_count) -- Обновление группы
nk.group_delete(group_id) -- Удаление группы
nk.group_users_list(group_id, limit, state, cursor) -- Список пользователей группы
nk.user_groups_list(user_id, limit, state, cursor) -- Список групп пользователя
nk.group_join(group_id, user_id, username) -- Присоединение к группе
nk.group_leave(group_id, user_id, username) -- Выход из группы
nk.group_add_user(group_id, user_id, username) -- Добавление пользователя в группу
nk.group_kick_user(group_id, user_id, username) -- Исключение пользователя из группы
nk.group_promote_user(group_id, user_id, username) -- Повышение пользователя в группе
nk.group_demote_user(group_id, user_id, username) -- Понижение пользователя в группе
nk.group_ban_user(group_id, user_id, username) -- Бан пользователя в группе
nk.group_unban_user(group_id, user_id, username) -- Разбан пользователя в группе

-- Лидерборды
nk.leaderboard_create(id, authoritative, sort, operator, reset, metadata, title, description, duration, category, start_time, end_time, join_required) -- Создание лидерборда
nk.leaderboard_delete(id) -- Удаление лидерборда
nk.leaderboard_records_list(id, limit, cursor, owner_ids) -- Список рекордов лидерборда
nk.leaderboard_record_write(id, owner_id, username, score, subscore, metadata) -- Запись рекорда в лидерборд
nk.leaderboard_record_delete(id, owner_id) -- Удаление рекорда из лидерборда

-- Турниры
nk.tournament_create(id, authoritative, sort, operator, reset, metadata, title, description, category, start_time, end_time, duration, max_size, max_num_score, join_required) -- Создание турнира
nk.tournament_delete(id) -- Удаление турнира
nk.tournament_add_attempt(id, owner_id, count) -- Добавление попыток в турнир
nk.tournament_join(id, user_id, username) -- Присоединение к турниру
nk.tournament_list(category_start, category_end, start_time, end_time, limit, cursor) -- Список турниров
nk.tournament_record_write(id, owner_id, username, score, subscore, metadata) -- Запись рекорда в турнир
nk.tournaments_get_id(tournament_ids) -- Получение турниров по ID

-- Уведомления
nk.notifications_send(user_id, subject, content, code, sender_id, persistent) -- Отправка уведомления
nk.notifications_send_all(subject, content, code, persistent) -- Отправка уведомления всем пользователям

-- Кошельки
nk.wallet_update(user_id, changeset, metadata, update_ledger) -- Обновление кошелька пользователя
nk.wallet_ledger_list(user_id, limit, cursor) -- Список транзакций кошелька
nk.wallet_ledger_update(user_id, transaction_id, metadata) -- Обновление транзакции кошелька

-- Инвентарь
nk.inventory_list(user_id, limit, cursor) -- Список инвентаря
nk.inventory_update(user_id, changeset) -- Обновление инвентаря

-- Сообщения
nk.channel_message_send(channel_id, content, sender_id, sender_username, persist) -- Отправка сообщения в канал
nk.channel_message_update(channel_id, message_id, content) -- Обновление сообщения в канале
nk.channel_message_remove(channel_id, message_id, sender_id) -- Удаление сообщения из канала
nk.channel_id_build(target_id, type) -- Построение ID канала

-- Матчи
nk.match_create(module, params) -- Создание матча
nk.match_get(id) -- Получение матча по ID
nk.match_list(limit, authoritative, label, min_size, max_size, query) -- Список матчей
nk.match_signal(id, data) -- Отправка сигнала в матч

-- Общие
nk.logger_debug(message) -- Логирование дебаг сообщения
nk.logger_info(message) -- Логирование информационного сообщения
nk.logger_warn(message) -- Логирование предупреждения
nk.logger_error(message) -- Логирование ошибки
nk.uuid_v4() -- Генерация UUID v4
nk.json_encode(value) -- Кодирование в JSON
nk.json_decode(value) -- Декодирование из JSON
nk.base64_encode(value) -- Кодирование в Base64
nk.base64_decode(value) -- Декодирование из Base64
nk.base64url_encode(value) -- Кодирование в Base64URL
nk.base64url_decode(value) -- Декодирование из Base64URL
nk.http_request(url, method, headers, body, timeout) -- HTTP запрос
nk.sql_exec(query, parameters) -- Выполнение SQL запроса
nk.sql_query(query, parameters) -- Выполнение SQL запроса с возвратом результата
nk.time() -- Текущее время в миллисекундах
nk.cron_create(id, name, schedule, module, module_args) -- Создание задачи по расписанию
nk.cron_delete(id) -- Удаление задачи по расписанию