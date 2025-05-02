FROM heroiclabs/nakama-pluginbuilder:3.20.0

COPY ./modules /nakama/data/modules

CMD ["nakama", "--name", "default", "--server_key", "defaultkey", "--console.port", "7352"]