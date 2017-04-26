# Basic spawning
defmodule SpawnBasic do
  def greet do
    IO.puts "Hello"
  end

  def run do
    greet
    spawn(__MODULE__, :greet, [])
  end

end

# Message send and return
defmodule Spawn1 do
  def greet do
    receive do
      {sender, msg} -> send sender, {:ok, "Hello #{msg}"}
    end
  end

  def run do
    pid = spawn(__MODULE__, :greet, [])

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
    end
  end
end

# Demonstrate hanging
defmodule Spawn2 do
  def greet do
    receive do
      {sender, msg} -> send sender, {:ok, "Hello #{msg}"}
    end
  end

  def run do
    pid = spawn(__MODULE__, :greet, [])

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
    end

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
    end
  end
end

# Demonstrate timeouts
defmodule Spawn3 do
  def greet do
    receive do
      {sender, msg} -> send sender, {:ok, "Hello #{msg}"}
    end
  end

  def run do
    pid = spawn(__MODULE__, :greet, [])

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
    end

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
      after 500 -> "The greeter has gone away"
    end
  end
end

# Demonstrate using recursion to keep processing messages
# Demonstrate timeouts
defmodule Spawn4 do
  def greet do
    receive do
      {sender, msg} ->
        send sender, {:ok, "Hello #{msg}"}
        greet
    end
  end

  def run do
    pid = spawn(__MODULE__, :greet, [])

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
    end

    send(pid, {self, "World!"})
    receive do
      {:ok, message} -> IO.puts message
      after 500 -> "The greeter has gone away"
    end
  end
end

# Examine expense of running processes
defmodule Chain do
  def counter(x, next_pid) do
    receive do
      n ->
        IO.puts "#{x} -> #{n}"
        send next_pid, n + 1
    end
  end

  def create_processes(n) do
    last = Enum.reduce(1..n, self,
      fn(x, send_to) -> spawn(__MODULE__, :counter, [x, send_to]) end)
    send last, 0

    receive do
      final_answer when is_integer(final_answer) ->
        "Result is #{inspect(final_answer)}"
    end
  end

  def run(n) do
    IO.puts inspect :timer.tc(__MODULE__, :create_processes, [n])
  end
end

defmodule Monitor1 do
  import :timer, only: [ sleep: 1]

  def sad_function do
    sleep 500
    exit :boom
  end

  def run do
    res = spawn_monitor(__MODULE__, :sad_function, [])
    IO.puts "#{__MODULE__}, #{inspect res}"
    receive do
      msg ->
        IO.puts "MESSAGE RECEIVED: #{inspect msg}"
    after 1000 ->
        IO.puts "Nothing happened."
    end
  end
end

defmodule WorkingWithMultipleProcesses3 do
  import :timer, only: [ sleep: 1]

  def short_lived(parent) do
    IO.puts ":short_lived"
    send parent, "A Message"
  end

  def process_messages do
    receive do
      msg ->
        IO.puts "#{inspect msg}"
        process_messages
    after 1000 ->
      IO.puts "Didn't get anything else, dying"
    end
  end

  def run do
    spawn_link(__MODULE__, :short_lived, [self])
    sleep 500
    process_messages
  end
end

defmodule WorkingWithMultipleProcesses4 do
  import :timer, only: [ sleep: 1]

  def short_lived(parent) do
    IO.puts ":short_lived"
    raise "foo"
  end

  def process_messages do
    receive do
      msg ->
        IO.puts "#{inspect msg}"
        process_messages
    after 1000 ->
      IO.puts "Didn't get anything else, dying"
    end
  end

  def run do
    spawn_link(__MODULE__, :short_lived, [self])
    sleep 500
    process_messages
  end
end

defmodule WorkingWithMultipleProcesses5a do
  import :timer, only: [ sleep: 1]

  def short_lived(parent) do
    IO.puts ":short_lived"
    send parent, "A Message"
  end

  def process_messages do
    receive do
      msg ->
        IO.puts "#{inspect msg}"
        process_messages
    after 1000 ->
      IO.puts "Didn't get anything else, dying"
    end
  end

  def run do
    spawn_monitor(__MODULE__, :short_lived, [self])
    sleep 500
    process_messages
  end
end

defmodule WorkingWithMultipleProcesses5b do
  import :timer, only: [ sleep: 1]

  def short_lived(parent) do
    IO.puts ":short_lived"
    raise "foo"
  end

  def process_messages do
    receive do
      msg ->
        IO.puts "#{inspect msg}"
        process_messages
    after 1000 ->
      IO.puts "Didn't get anything else, dying"
    end
  end

  def run do
    spawn_monitor(__MODULE__, :short_lived, [self])
    sleep 500
    process_messages
  end
end

defmodule Parallel do
  def pmap(collection, func) do
    me = self()
    collection
    |> Enum.map(fn(elem) -> spawn_link(fn -> send me, {self(), func.(elem)} end) end)
    |> Enum.map(fn(pid) -> receive do {^pid, result} -> result end end)
  end

  def bad_pmap(collection, func) do
    me = self()
    collection
    |> Enum.map(fn(elem) -> spawn_link(fn -> send me, {self(), func.(elem)} end) end)
    |> Enum.map(fn(pid) -> receive do {pid, result} -> result end end)
  end
end

# WorkingWithMultipleProcesses2, p194
defmodule WorkingWithMultipleProcesses2 do
  def echo do
    receive do
      {sender, token} -> send sender, token
    end
  end

  def run do
    pid1 = spawn(WorkingWithMultipleProcesses2, :echo, [])
    pid2 = spawn(WorkingWithMultipleProcesses2, :echo, [])

    send pid1, {self, "token1"}
    send pid2, {self, "token2"}

    receive do
      token -> IO.puts "#{token}"
    end

    receive do
      token -> IO.puts "#{token}"
    end
  end
end

# Link1
defmodule Link1 do
  import :timer, only: [ sleep: 1 ]

  def sad_function do
    sleep 500
    exit(:boom)
  end

  def run do
    spawn(Link1, :sad_function, [])
    receive do
      msg ->
        IO.puts "Message Received: #{inspect msg}"
    after 1000 ->
        IO.puts "Nothing happened"
    end
  end
end

# Link2
defmodule Link2 do
  import :timer, only: [ sleep: 1 ]

  def sad_function do
    sleep 500
    exit(:boom)
  end

  def run do
    spawn_link(Link2, :sad_function, [])
    receive do
      msg ->
        IO.puts "Message Received: #{inspect msg}"
    after 1000 ->
        IO.puts "Nothing happened"
    end
  end
end

# Link3
defmodule Link3 do
  import :timer, only: [ sleep: 1 ]

  def sad_function do
    sleep 500
    exit(:boom)
  end

  def run do
    Process.flag(:trap_exit, true)
    spawn_link(Link2, :sad_function, [])
    receive do
      {:EXIT, pid, :boom} ->
        IO.puts "Exit message received"
      msg ->
        IO.puts "Message Received: #{inspect msg}"
    after 1000 ->
        IO.puts "Nothing happened"
    end
  end
end
