defmodule Day1.PartOne do
  def run do
    input_path = "./input.txt"

    input_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, sum -> (
      sum + parse_line_to_num(line)
    end))
  end

  defp parse_line_to_num(line) do
    line
    |> String.replace("\n", "")
    |> String.replace("\r", "")
    |> Integer.parse()
  end
end