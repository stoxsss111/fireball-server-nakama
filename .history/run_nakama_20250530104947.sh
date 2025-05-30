#!/bin/bash

echo "💾 Сохраняем проект (вручную через Ctrl+S перед этим)"

echo "🔄 Перезапуск Docker-контейнера Nakama"
docker restart nakama_node

echo "⏳ Ждём, пока контейнер поднимется..."
sleep 3

echo "🚀 Запускаем основной скрипт"
lua main.lua  # или любая другая команда
