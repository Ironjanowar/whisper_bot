defmodule WhisperBot.Transcriber do
  use GenServer

  require Logger

  alias WhisperBot.TranscriberSupervisor

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def async_transcribe(chat_id, message_id, file_id) do
    GenServer.cast(__MODULE__, {:transcribe, chat_id, message_id, file_id})
  end

  def init(:ok), do: {:ok, %{}}

  def handle_cast({:transcribe, chat_id, message_id, file_id}, state) do
    task =
      Task.Supervisor.async_nolink(TranscriberSupervisor, fn -> WhisperBot.transcribe(file_id) end)

    {:noreply, Map.put(state, task.ref, {chat_id, message_id})}
  end

  def handle_info({ref, result}, state) do
    if state[ref] do
      Process.demonitor(ref, [:flush])
      {{chat_id, message_id}, new_state} = Map.pop(state, ref)

      edit_message(result, chat_id, message_id)

      {:noreply, new_state}
    else
      # TODO: log received task result that was not in the state
      {:noreply, state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, reason}, state) do
    {{chat_id, message_id}, new_state} = Map.pop(state, ref)

    edit_message({:error, reason}, chat_id, message_id)

    {:noreply, new_state}
  end

  def transcribe_file(file_path) do
    case Nx.Serving.batched_run(Whisper, {:file, file_path}) do
      %{results: [%{text: text}]} ->
        {:ok, text}

      error ->
        Logger.warn("Transcribe error: #{inspect(error)}")
        {:error, "Could not transcribe"}
    end
  end

  defp edit_message({:ok, text}, chat_id, message_id),
    do: WhisperBot.MessageEditor.edit_message_with(chat_id, message_id, text)

  defp edit_message(error, chat_id, message_id) do
    Logger.error("Transcription error: #{inspect(error)}")

    message = "Could not transcribe the message sorry :/"
    WhisperBot.MessageEditor.edit_message_with(chat_id, message_id, message)
  end
end
