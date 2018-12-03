defmodule Day1 do
  defmodule Counter do
    defstruct(
      freq: 0,
      state: :not_found,
      counts: %{}
    ) 
  end

  alias Day1.Counter

  @input_path "./input.txt"

  def run do
    IO.inspect part_one(), label: "Part 1"
    IO.inspect part_two(), label: "Part 2"
  end

  def part_one do
    @input_path
    |> File.stream!()
    |> Enum.reduce(0, fn line, freq -> (
      freq + parse_line_to_num(line)
    )end)
  end

  def part_two(c \\ %Counter{})
  def part_two(%Counter{state: :found, freq: repeated_freq}), do: repeated_freq
  def part_two(%Counter{state: :not_found} = c) do
    ans = 
      @input_path
      |> File.stream!()
      |> Enum.reduce_while(c, fn line, %Counter{freq: f, counts: counts} -> (
        cur_num = parse_line_to_num(line)
        freq = f + cur_num

        case Map.get(counts, freq) do
          nil -> {:cont, %{c |  counts: Map.put(counts, freq, 1), freq: freq}}
          _ -> {:halt, %{c | state: :found, freq: freq}}
        end
      )end)

    part_two(ans)
  end


  defp parse_line_to_num(line) do
    line
    |> String.replace("\n", "")
    |> String.replace("\r", "")
    |> String.to_integer()
  end
end
