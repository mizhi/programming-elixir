defmodule Chapter7 do

  # Problem 0, p68
  def sum([]), do: 0
  def sum([x|xs]) do
    x + sum(xs)
  end

  # Problem 1, p69
  def mapsum(xs, func), do: _mapsum(xs, func, 0)

  defp _mapsum([], _func, total), do: total

  defp _mapsum([x|xs], func, total) do
    _mapsum(xs, func, total + func.(x))
  end

  # Problem 2, p69
  def max([x|xs]), do: _max(xs, x)

  defp _max([], current), do: current

  defp _max([x|xs], current) do
    cond do
      x > current -> _max(xs, x)
      true -> _max(xs, current)
    end
  end

  # Problem 3, p69
  def caesar(s, n), do: _caesar(s, n, '')

  defp _caesar([], _n, final), do: final

  defp _caesar([c| s], n, final) do
    _caesar(s, n, final ++ [_caesar_char(c, n)])
  end

  defp _caesar_char(c, n) do
    rem((c - ?a) + n, 26) + ?a
  end

  # Problem 4, p72
  def span(from, to) do
    _span(from, to, [])
  end

  defp _span(from, to, accum) do
    if from == to do
      [from | accum]
    else
      _span(from, to - 1, [to | accum])
    end
  end
end
