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
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"

config :logger, :error,
  path: "log/error.log",
  level: :error,
  format: "$dateT$timeZ [$level] $message\n"

config :nx, default_backend: EXLA.Backend
