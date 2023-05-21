# WhisperBot

# Deploy your own WhisperBot

## Create a bot in Telegram

Send `/newbot` to [BotFather](https://t.me/BotFather) and follow the steps to create a bot.

Copy the bot token provided by BotFather and create a `bot.token` file in the base of this repository with the token in it.

## Create the release

Execute `MIX_ENV=prod make release` to create a release that will only log errors to the `log/error.log` file

## Start the release

Execute `MIX_ENV=prod make start` to start the release

Send `/start` or `/help` to your bot in Telegram to verify that it is running

## Stop the release

Execute `MIX_ENV=prod make stop` to stop the release
