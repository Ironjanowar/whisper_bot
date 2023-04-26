defmodule WhisperBot.Bot do
  @bot :whisper_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start")
  command("help", description: "Print the bot's help")

  middleware(ExGram.Middleware.IgnoreUsername)

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!") |> IO.inspect(label: "start")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:message, %{voice: %{file_id: file_id}} = msg}, _context) do
    %{chat: %{id: chat_id}, message_id: message_id} = msg

    opts = [reply_to_message_id: message_id]
    {:ok, %{message_id: message_id}} = ExGram.send_message(chat_id, "Processing audio...", opts)

    WhisperBot.async_transcribe(chat_id, message_id, file_id)
  end
end
