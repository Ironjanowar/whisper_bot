defmodule WhisperBot.Client do
  use Tesla

  def client() do
    token = ExGram.Config.get(:ex_gram, :token)

    middlewares = [{Tesla.Middleware.BaseUrl, "https://api.telegram.org/file/bot#{token}/"}]

    Tesla.client(middlewares)
  end

  def download(file_path) do
    case client() |> get(file_path) do
      {:ok, %{body: binary}} -> {:ok, binary}
      error -> error
    end
  end
end
