defmodule Chapter9 do
  # p92, Problem 1
  def all?([]), do: true
  def all?([x|xs]), do: x && all?(xs)

  def all?([], _func), do: true
  def all?([x|xs], func), do: func.(x) && all?(xs, func)

  def each([], _func), do: :ok
  def each([x|xs], func) do
    func.(x)
    each(xs, func)
  end

  def filter(xs, func), do: _filter(xs, func, [])

  defp _filter([], _func, acc), do: acc
  defp _filter([x|xs], func, acc) do
    if func.(x) do
      _filter(xs, func, acc ++ [x])
    else
      _filter(xs, func, acc)
    end
  end

  def split(xs, n), do: _split(xs, n, [])
  defp _split(xs, 0, acc), do: [acc, xs]
  defp _split([x|xs], n, acc), do: _split(xs, n - 1, acc ++ [x])

  def take(xs, n), do: _take(xs, n, [])
  defp _take([], _, acc), do: Enum.reverse(acc)
  defp _take([x|xs], 0, acc), do: Enum.reverse(acc)
  defp _take([x|xs], n, acc), do: _take(xs, n - 1, [x|acc])

  # p92, Problem 2
  def flatten(xs), do: _flatten(xs, [])
  defp _flatten([], acc), do: Enum.reverse(acc)
  defp _flatten([[]|xs], acc), do: _flatten(xs, acc)
  defp _flatten([[x|xs]|[]], acc), do: _flatten(xs, [x|acc])
  defp _flatten([[x|xs]|ys], acc), do: _flatten([xs|ys], [x|acc])
  defp _flatten([x|xs], acc), do: _flatten(xs, [x| acc])
end
