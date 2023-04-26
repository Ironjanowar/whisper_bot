defmodule WhisperBot do
  def transcribe(file_id) do
    with {:ok, file_path} <- WhisperBot.Downloader.download_from_file_id(file_id),
         {:ok, transcription} <- WhisperBot.Transcriber.transcribe_file(file_path),
         :ok <- File.rm(file_path) do
      {:ok, transcription}
    end
  end

  defdelegate async_transcribe(chat_id, message_id, file_id), to: WhisperBot.Transcriber
end
