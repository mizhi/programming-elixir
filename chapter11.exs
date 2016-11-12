defmodule Chapter11 do
  # Problem 1, p112
  def printable?(s) do
    Enum.all?(s, &(?\s <= &1 && &1 <= ?~))
  end

  # Problem 2, p113
  def anagram?(word1, word2) do
    inw1 = word1 -- word2
    inw2 = word2 -- word1
    length(inw1) == 0 && length(inw2) == 0
  end

  # Problem 3, p113
  # [ 'cat' | 'dog' ] is making a new list that looks like [['c', 'a', 't'], 'd', 'o', 'g']
  # Verify: length(['cat'| 'dog']) == 4

  # Problem 4, p113 (Programming Elixir 1.3)
  def calculate(eq) do
    ~r/^\s*(?<num1>\d+)\s*(?<op>[\+\*\-\/])\s*(?<num2>\d+)$/ |>
      Regex.named_captures(eq) |>
      Map.update!("num1", &String.to_integer/1) |>
      Map.update!("num2", &String.to_integer/1) |>
      _compute
  end

  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "+" }), do: num1 + num2
  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "-" }), do: num1 - num2
  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "*" }), do: num1 * num2
  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "/" }), do: div(num1, num2)
end
