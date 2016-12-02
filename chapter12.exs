defmodule FizzBuzz do
  def upto(n) when n > 0, do: _downto(n, [])

  defp _downto(0, result), do: result
  defp _downto(current, result) do
    next_answer =
      cond do
      rem(current, 3) == 0 and rem(current, 5) == 0 -> "FizzBuzz"
      rem(current, 3) == 0 -> "Fizz"
      rem(current, 5) == 0 -> "Buzz"
      true -> current
    end
    _downto(current - 1, [next_answer | result])
  end
end

defmodule FizzBuzz2 do
  def upto(n) when n > 0, do: 1..n |> Enum.map(&fizzbuzz/1)

  defp fizzbuzz(n), do: _fizzbuzz(n, rem(n, 3), rem(n, 5))
  defp _fizzbuzz(_, 0, 0), do: "FizzBuzz"
  defp _fizzbuzz(_, 0, _), do: "Fizz"
  defp _fizzbuzz(_, _, 0), do: "Buzz"
  defp _fizzbuzz(n, _, _), do: n
end

# ControlFlow-1, p135 (PE 1.3)
defmodule FizzBuzz3 do
  def upto(n) when n > 0, do: 1..n |> Enum.map(&fizzbuzz/1)

  defp fizzbuzz(n) do
    case { n, rem(n, 3), rem(n, 5) } do
      { _, 0, 0 } -> "FizzBuzz"
      { _, 0, _ } -> "Fizz"
      { _, _, 0 } -> "Buzz"
      { n, _, _ } -> n
    end
  end
end

# ControlFlow-2, p135 (PE 1.3)
#
# Definitely prefer FizzBuzz2 or FizzBuzz3. FizzBuzz2 is nice in that each
# function is individually testable.  FizzBuzz3 is nice in that it's contained
# in one function and the pattern match is pretty easy to follow. However,
# a tuple that is much larger than that would be a bit unmanageable.

# ControlFlow-3, p136 (PE 1.3)
defmodule Chapter12 do
  def ok!({:ok, data}), do: data
  def ok!({_, info}) do
    raise info
  end
end
