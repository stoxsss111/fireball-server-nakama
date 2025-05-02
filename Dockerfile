# Стадия 1 — сборка плагинов
FROM heroiclabs/nakama-pluginbuilder:3.20.0 as builder

COPY ./modules /nakama/data/modules
RUN go build -buildmode=plugin -o /plugin.so /nakama/data/modules/*.go

# Стадия 2 — запуск Nakama с собранным плагином
FROM heroiclabs/nakama:3.20.0

COPY --from=builder /plugin.so /nakama/data/modules/plugin.so

CMD ["nakama", "--name", "default", "--server_key", "defaultkey", "--console.port", "7352"]
