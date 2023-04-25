raw = File.read!("./audio.ogg")

audio =
  raw
  |> Nx.from_binary(:f32)
  |> Nx.reshape({:auto, 1})
  |> Nx.mean(axes: [1])

Nx.Serving.batched_run(Whisper, audio)
