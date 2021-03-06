defmodule Chapter10 do
  # ListsAndRecursion-5, p98 (PE 1.3)
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

  # ListsAndRecursion-6, p98 (PE 1.3)
  def flatten(xs), do: _flatten(xs, [])
  defp _flatten([], acc), do: Enum.reverse(acc)
  defp _flatten([[]|xs], acc), do: _flatten(xs, acc)
  defp _flatten([[x|xs]|[]], acc), do: _flatten(xs, [x|acc])
  defp _flatten([[x|xs]|ys], acc), do: _flatten([xs|ys], [x|acc])
  defp _flatten([x|xs], acc), do: _flatten(xs, [x| acc])

  # ListsAndRecursion-7, p110 (PE 1.3)
  def primes(n) do
    Chapter7.span(2, n)
    |> Enum.filter(&_prime/1)
  end

  def _prime(1), do: false

  def _prime(n) do
    (2..n) |> Enum.filter(fn x -> rem(n, x) == 0 end) |> length() == 1
  end

  # ListsAndRecursion-8, p110 (PE 1.3)
  @tax_rates [ NC: 0.075, TX: 0.08 ]
  @orders [
    [ id: 123, ship_to: :NC, net_amount: 100.00 ],
    [ id: 124, ship_to: :OK, net_amount: 35.50 ],
    [ id: 125, ship_to: :TX, net_amount: 24.00 ],
    [ id: 126, ship_to: :TX, net_amount: 44.80 ],
    [ id: 127, ship_to: :NC, net_amount: 25.00 ],
    [ id: 128, ship_to: :MA, net_amount: 10.00 ],
    [ id: 129, ship_to: :CA, net_amount: 102.00 ],
    [ id: 130, ship_to: :NC, net_amount: 50.00 ]
  ]

  def tax_rates, do: @tax_rates
  def orders, do: @orders

  def add_total_to_orders(orders, tax_rates) do
    orders
    |> Enum.map(&(add_total_to_order(&1, tax_rate_for_order(&1, tax_rates))))
  end

  def add_total_to_orders2(orders, tax_rates) do
    for order <- orders do
      add_total_to_order(order, tax_rate_for_order(order, tax_rates))
    end
  end

  def tax_rate_for_order(order, tax_rates) do
    Dict.get(tax_rates, Dict.get(order, :ship_to), 0.0)
  end

  def add_total_to_order(order, tax_rate) do
    Dict.put(
      order,
      :total_amount,
      Dict.get(order, :net_amount) * (1.0 + tax_rate)
    )
  end
end
