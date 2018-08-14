defmodule SpeedTestTest do
  use ExUnit.Case
  doctest SpeedTest

  test "greets the world" do
    assert SpeedTest.hello() == :world
  end
end
