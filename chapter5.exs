# Functions-1, p39 (PE 1.3)
list_concat = fn (xs, ys) -> xs ++ ys end
IO.inspect list_concat.([:a, :b], [:c, :d])

sum = fn (x, y, z) -> x + y + z end
IO.inspect sum.(1, 2, 3)

pair_tuple_to_list = fn ({a, b}) -> [a, b] end
IO.inspect pair_tuple_to_list.({3, 6})

# Functions-2, p41 (PE 1.3)
fizz_buzz = fn
  (0, 0, _) -> "FizzBuzz"
  (0, _, _) -> "Fizz"
  (_, 0, _) -> "Buzz"
  (_, _, x) -> x
end

# Functions-3, p41 (PE 1.3)
fzz_bzz = fn
  (x) -> fizz_buzz.(rem(x, 3), rem(x, 5), x)
end

IO.puts fzz_bzz.(10)
IO.puts fzz_bzz.(11)
IO.puts fzz_bzz.(12)
IO.puts fzz_bzz.(13)
IO.puts fzz_bzz.(14)
IO.puts fzz_bzz.(15)
IO.puts fzz_bzz.(16)

# Functions-4, p43 (PE 1.3)
prefix = fn
  (px) -> fn
    (x) -> px <> x
  end
end

mrs = prefix.("Mrs.")
IO.puts mrs.("Smith")

# Functions-5, p46 (PE 1.3)
IO.inspect Enum.map [1,2,3,4], fn x -> x + 2 end
IO.inspect Enum.map [1,2,3,4], &(&1 + 2)

IO.inspect Enum.each [1,2,3,4], fn x -> IO.inspect x end
IO.inspect Enum.each [1,2,3,4], &IO.inspect/1
