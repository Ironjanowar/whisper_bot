defmodule WhisperBot.MessageEditor do
  use GenServer

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def edit_message_with(chat_id, message_id, text) do
    GenServer.cast(__MODULE__, {:edit, chat_id, message_id, text})
  end

  def init(:ok), do: {:ok, %{}}

  def handle_cast({:edit, chat_id, message_id, text}, state) do
    params = [chat_id: chat_id, message_id: message_id]

    with {:error, error} <- ExGram.edit_message_text(text, params) do
      Logger.error("Error editing message_id #{message_id}: #{inspect(error)}")
    end

    {:noreply, state}
  end
end
