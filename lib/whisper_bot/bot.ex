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
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "Here is your help:")
  end

  def handle({:message, %{voice: %{file_id: file_id}}}, context) do
    case WhisperBot.transcribe(file_id) do
      {:ok, transcription} -> answer(context, transcription)
      _ -> answer(context, "Unknown error sorry :(")
    end
  end
end
