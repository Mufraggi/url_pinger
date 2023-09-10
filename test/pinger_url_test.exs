defmodule PingerUrlTest do
  use ExUnit.Case
  doctest PingerUrl

  test "greets the world" do
    assert PingerUrl.hello() == :world
  end
end
