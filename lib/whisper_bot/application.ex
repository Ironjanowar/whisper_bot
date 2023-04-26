defmodule WhisperBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      {Task.Supervisor, name: WhisperBot.TranscriberSupervisor},
      WhisperBot.MessageEditor,
      WhisperBot.Transcriber,
      {Nx.Serving, serving: serving(), name: Whisper},
      ExGram,
      {WhisperBot.Bot, [method: :polling, token: token]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WhisperBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp serving() do
    {:ok, model_info} = Bumblebee.load_model({:hf, "sgangireddy/whisper-largev2-mls-es"})
    {:ok, featurizer} = Bumblebee.load_featurizer({:hf, "sgangireddy/whisper-largev2-mls-es"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "openai/whisper-large-v2"})
    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, "openai/whisper-large-v2"})

    generation_config = Bumblebee.configure(generation_config, max_new_tokens: 100)

    Bumblebee.Audio.speech_to_text(model_info, featurizer, tokenizer, generation_config,
      compile: [batch_size: 1],
      defn_options: [compiler: EXLA]
    )
  end
end
