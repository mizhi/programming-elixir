defmodule Chapter6 do
  def double(n) do
    n * 2
  end

  # Problem 1, p45
  def triple(n) do
    n * 3
  end

  # Problem 3, p45
  def quadruple(n) do
    double(n) * 2
  end

  # Problem 4, p47
  def sum(0), do: 0
  def sum(n) when n > 0, do: n + sum(n - 1)

  # Problem 5, p47
  def gcd(x, 0), do: x
  def gcd(x, y), do: gcd(y, rem(x, y))

  # Problem 6, p52

  # using guards
  def chop(x, min, max) when min < max and x >= min and x <= max, do: chop(x, min, max, div(min + max, 2))
  def chop(x, min, max, mid) when x == mid, do: x
  def chop(x, min, max, mid) when x < mid, do: chop(x, min, mid)
  def chop(x, min, max, mid) when x > mid, do: chop(x, mid, max)

  # One function, no guard
  def chop2(x, min, max) when min < max and x >= min and x <= max do
    mid = div(min + max, 2)

    cond do
      mid == x -> x
      x < mid -> chop2(x, min, mid)
      x > mid -> chop2(x, mid, max)
    end
  end

  # Problem 7, p59
  def float_to_string(x) do
    :io.format("~.2f~n", [x])
  end

  def op_env do
    System.get_env("HOME")
  end

  def file_ext(fname) do
    Path.extname(fname)
  end

  def proc_cwd do
    System.cwd
  end

  def run_cmd do
    System.cmd "echo", ["foo", "bar", "gaz"]
  end
end
