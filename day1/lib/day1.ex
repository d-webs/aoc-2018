defmodule Day1 do
  def run do
    IO.inspect part_one(), label: "Part 1"
  end

  def part_one do
    input_path = "./input.txt"

    input_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, sum -> (
      {num, _} = parse_line_to_num(line)
      sum + num
      )
    end)
  end

  def part_two do
    
  end

  defp parse_line_to_num(line) do
    line
    |> String.replace("\n", "")
    |> String.replace("\r", "")
    |> Integer.parse()
  end
end
