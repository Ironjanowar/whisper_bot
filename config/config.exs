import Config

config :whisper_bot, WhisperBot.Repo,
  database: "whisper_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :whisper_bot,
  ecto_repos: [WhisperBot.Repo]

config :ex_gram,
  token: {:system, "BOT_TOKEN"}

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}]

config :nx, default_backend: EXLA.Backend

import_config "#{Mix.env()}.exs"
