defmodule FuncRunner do
  def run_func(scheduler, func) do
    send scheduler, {:ready, self()}
    receive do
      {:run_func, arg, client} ->
        send client, {:answer, arg, func.(arg), self()}
        run_func(scheduler, func)
      {:shutdown} ->
        exit(:normal)
    end
  end
end

defmodule Scheduler do
  def run(num_processes, func, to_calculate) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(FuncRunner, :run_func, [self(), func]) end)
    |> schedule_processes(to_calculate, [])
  end

  def schedule_processes(processes, work_queue, results) do
    receive do
      {:ready, pid} when length(work_queue) > 0 ->
        [ next | tail ] = work_queue
        send pid, {:run_func, next, self()}
        schedule_processes(processes, tail, results)
      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), work_queue, results)
        else
          results
        end
      {:answer, arg, answer, _pid} ->
        schedule_processes(processes, work_queue, [{arg, answer} | results])
    end
  end
end

defmodule PathFinder do
  def walk(path), do: walk([path], [])

  defp walk([], results), do: results
  defp walk([file_name|file_names], results) do
    cond do
      File.dir?(file_name)     -> walk(file_names ++ absls!(file_name), results)
      File.regular?(file_name) -> walk(file_names, [file_name | results])
      true                     -> results
    end
  end

  defp absls!(path) do
    File.ls!(path)
    |> Enum.map(&Path.absname(&1, path))
  end
end

defmodule PathCounter do
  def count(path, word) do
    files = PathFinder.walk(path)

    IO.puts "#{length(files)}"

    results = Scheduler.run(
      length(files),
      fn(file_name) ->
        (File.read!(file_name)
         |> String.split(word)
         |> length) - 1
      end,
      files
    )

    results |> Enum.reduce(0, fn({_, count}, acc) -> acc + count end)
  end
end
