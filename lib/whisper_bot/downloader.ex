defmodule WhisperBot.Downloader do
  alias WhisperBot.Client

  def download_from_file_id(file_id) do
    with {:ok, %{file_path: path}} <- ExGram.get_file(file_id),
         {:ok, file_binary} <- Client.download(path),
         :ok <- path |> Path.dirname() |> File.mkdir_p(),
         :ok <- File.write(path, file_binary) do
      {:ok, path}
    end
  end
end
