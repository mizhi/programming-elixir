defmodule Chapter11 do
  # StringsAndBinaries-1, p119 (PE 1.3)
  def printable?(s) do
    Enum.all?(s, &(?\s <= &1 && &1 <= ?~))
  end

  # StringsAndBinaries-2, p119 (PE 1.3)
  def anagram?(word1, word2) do
    inw1 = word1 -- word2
    inw2 = word2 -- word1
    length(inw1) == 0 && length(inw2) == 0
  end

  # StringsAndBinaries-3, p119 (PE 1.3)
  # [ 'cat' | 'dog' ] is making a new list that looks like [['c', 'a', 't'], 'd', 'o', 'g']
  # Verify: length(['cat'| 'dog']) == 4

  # StringsAndBinaries-4, p119 (PE 1.3)
  def calculate(eq) do
    ~r/^\s*(?<num1>\d+)\s*(?<op>[\+\*\-\/])\s*(?<num2>\d+)$/
    |> Regex.named_captures(eq)
    |> Map.update!("num1", &String.to_integer/1)
    |> Map.update!("num2", &String.to_integer/1)
    |> _compute
  end

  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "+" }), do: num1 + num2
  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "-" }), do: num1 - num2
  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "*" }), do: num1 * num2
  def _compute(%{ "num1" => num1, "num2" => num2, "op" => "/" }), do: div(num1, num2)

  # StringsAndBinaries-5, p126 (PE 1.3)
  def center(strings) do
    max_len = strings
    |> Enum.map(&String.length/1)
    |> Enum.max

    strings
    |> Enum.map(&(_centered(&1, max_len)))
    |> Enum.each(&IO.puts/1)
  end

  def _centered(string, width) do
    left = div(width + String.length(string), 2)
    string
    |> String.pad_leading(left)
    |> String.pad_trailing(width)
  end

  # StringsAndBinaries-6, p127 (PE 1.3)
  def capitalize_sentences(string) do
    string
    |> sentences
    |> Enum.map_join(&String.capitalize/1)
  end

  def sentences(string) do
    splits  = ~r/\.\ / |> Regex.replace(string, ". |$|")
    ~r/\|\$\|/ |> Regex.split(splits)
  end
  end
end
