defmodule WhisperBot.Transcriber do
  require Logger

  def transcribe_file(file_path) do
    case Nx.Serving.batched_run(Whisper, {:file, file_path}) do
      %{results: [%{text: text}]} ->
        {:ok, text}

      error ->
        Logger.warn("Transcribe error: #{inspect(error)}")
        {:error, "Could not transcribe"}
    end
  end
end
