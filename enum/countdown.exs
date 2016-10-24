defmodule Countdown do
  def timer do
    Stream.resource(
      fn ->
        {_h, _m, s} = :erlang.time
        60 - s - 1
      end,

      fn
        0 ->
          {:halt, 0}
        count ->
          { [count], count - 1 }
      end,

      fn _ -> end
    )
  end
end
