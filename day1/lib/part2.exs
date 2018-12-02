defmodule PartTwo do
  def run do
    # freq = 0
    input_path = "./input.txt"

    input_path
    |> File.stream!()
    |> add_line()
  end

  defp add_line(line) do
    IO.puts line
  end
end