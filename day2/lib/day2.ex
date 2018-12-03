defmodule Day2 do
  @input_path "./input.txt"

  def part_one do
    @input_path
    |> File.stream!()
    |> Enum.map(&(String.replace(&1, "\n", "")))
    |> Enum.reduce({0, 0}, fn line, {two_sum, three_sum} -> (
        {two_count, three_count} = letter_counts(line)

        {two_sum + two_count, three_sum + three_count}
      )end) 
    |> get_two_three_product()
  end

  def part_two do
    @input_path
    |> File.stream!()
    |> Enum.map(&(String.replace(&1, "\n", "")))
    |> Enum.reduce(%{}, fn line, words -> (
        Map.merge(words, subwords(line), fn _k, v1, v2 -> v1 + v2 end)
    )end)
    |> Enum.filter(fn {_, count} -> count > 1 end)
  end


  defp subwords(line) do
    chars = String.split(line, "", trim: true)

    Enum.reduce(0..length(chars) - 1, %{}, fn n, subs -> (
      sw = 
        chars
        |> List.delete_at(n)
        |> List.insert_at(n, "*")
        |> Enum.join()

      Map.update(subs, sw, 1, &(&1 + 1))
    )end)
  end
  
  defp get_two_three_product({two_sum, three_sum}) do
    two_sum * three_sum
  end

  defp letter_counts(line) do
    line
    |> String.split("", trim: true)
    |> Enum.reduce(%{}, fn ltr, counts -> (
        case Map.get(counts, ltr) do
          nil -> Map.put(counts, ltr, 1)
          1 -> Map.put(counts, ltr, 2)
          2 -> Map.put(counts, ltr, 3)
          :invalid -> counts
          _ -> Map.put(counts, ltr, :invalid)
        end
      )end)
    |> get_counts()
  end

  defp get_counts(count_map) do
    two? = if Enum.any?(count_map, fn {_,v} -> v == 2 end), do: 1, else: 0
    three? = if Enum.any?(count_map, fn {_,v} -> v == 3 end), do: 1, else: 0

    {two?, three?}
  end
end
