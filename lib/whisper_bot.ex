defmodule WhisperBot do
  def transcribe(file_id) do
    with {:ok, file_path} <- WhisperBot.Downloader.download_from_file_id(file_id),
         %{results: [%{text: transcription}]} <-
           Nx.Serving.batched_run(Whisper, {:file, file_path}),
         :ok <- File.rm(file_path) do
      {:ok, transcription}
    end
  end
end
