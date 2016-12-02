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

  # StringsAndBinaries-7, p127 (PE 1.3)
  #
  # Sticking strictly with the functions the problem suggests leads to the
  # solution in add_sales_tax/1. This has some properties that I'm not
  # particularly happy with.
  #
  # The problem is that the final line |> Enum.to_list forces the stream to be
  # evaluated in parse_order_data and the entire result is now in memory. If the
  # number of orders was obnoxiously large, this could be an issue.
  #
  # The problem is that we cannot simply remove the Enum.to_list call. If we do
  # that then this would be the resulting code:
  #
  # data_stream
  # |> Stream.map(&convert_data/1)
  # |> Stream.map(&Enum.zip(headers, &1))
  #
  # The IO.Stream returned is ultimately constructed on top of the io_device
  # passed into parse_order_data.  However, File.open!/3 automatically closes
  # the file once it has been processed, so when it passes the result to
  # Chapter10.add_total_to_orders, the stream is now backed by a closed file.
  # Thus, when the stream is finally evaluated in Chapter10.add_total_to_orders,
  # it will discover that the file backing the stream is no longer open:
  #
  # ** (IO.StreamError) error during streaming: the file server process is terminated
  #  (elixir) lib/io.ex:474: IO.each_stream/2
  #  (elixir) lib/stream.ex:1136: Stream.do_resource/5
  #  (elixir) lib/stream.ex:1284: Enumerable.Stream.do_each/4
  #  (elixir) lib/enum.ex:1627: Enum.reduce/3
  #  (elixir) lib/enum.ex:1188: Enum.map/2
  #
  # One solution would be to open the file separately (potentially in a with
  # block) and manually close the file when Chapter10.add_total_to_orders has
  # finished processing the stream.
  #
  # An easier solution is presented in add_sales_tax2. This has the advantage in that
  # the stream behaves closer to what one would expect from an immutable stream, that is
  #
  # a_stream = File.stream!("a_file.txt")
  # first = a_stream |> Stream.take(1)
  # rest = a_stream |> Stream.drop(1)
  #
  # gives us the first element in the stream and then the rest of the elements
  #
  # When it is something like
  #
  # a_stream = io_device |> IO.stream
  # first = a_stream |> Stream.take(1)
  # rest = a_stream |> Stream.drop(1)
  #
  # we wind up missing line 2, because the stream is representing an underlying
  # abstraction that has side effects (namely, advancing the file pointer on the
  # system).
  #
  # I suppose one disadvantage of doing it this way is that everytime the stream
  # is evaluated it re-opens the file to perform the operations.
  #
  # Since this is a short-lived process, it also may be reasonable to simply
  # open the file without worrying about closing it. Open file handles are
  # automatically closed when the elixir process exits.
  def add_sales_tax(order_file) do
    order_file
    |> File.open!([:read], &parse_order_data/1)
    |> Chapter10.add_total_to_orders(Chapter10.tax_rates)
  end

  def parse_order_data(io_device) do
    data_stream = io_device
    |> IO.stream(:line)
    |> Stream.reject(&empty?/1)
    |> Stream.map(&split_csv_line/1)

    headers = data_stream
    |> Stream.take(1)
    |> Enum.to_list
    |> List.first
    |> Enum.map(&String.to_atom/1)

    data_stream
    |> Stream.map(&convert_data/1)
    |> Stream.map(&Enum.zip(headers, &1))
    |> Enum.to_list
  end

  def add_sales_tax2(order_file) do
    order_file
    |> File.stream!([:read], :line)
    |> parse_order_data2
    |> Chapter10.add_total_to_orders(Chapter10.tax_rates)
  end

  def parse_order_data2(data_stream) do
    lines = data_stream
    |> Stream.reject(&empty?/1)
    |> Stream.map(&split_csv_line/1)

    headers = lines
    |> Stream.take(1)
    |> Enum.to_list
    |> List.first
    |> Enum.map(&String.to_atom/1)

    lines
    |> Stream.drop(1)
    |> Stream.map(&convert_data/1)
    |> Stream.map(&Enum.zip(headers, &1))
  end

  def empty?(line) do
    0 == line |> String.trim |> String.length
  end

  def convert_data([id, ship_to, net_amount]) do
    [
      String.to_integer(id),
      ship_to |> String.slice(1..-1) |> String.to_atom,
      String.to_float(net_amount)
    ]
  end

  def split_csv_line(line) do
    line |> String.split(",") |> Enum.map(&String.trim/1)
  end
end
