defmodule WhisperBotTest do
  use ExUnit.Case
  doctest WhisperBot

  test "greets the world" do
    assert WhisperBot.hello() == :world
  end
end
