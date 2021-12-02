defmodule Words do
  def words do
    stream = File.stream!("./data/lorem")

    result =
      Enum.reduce(stream, 0, fn(line, acc) ->
        String.split(line, " ")
        |> Enum.count()
        |> Kernel.+(acc)
      end)

    IO.puts(result)
  end


  def words_flow do
    stream = File.stream!("./data/lorem")

    result =
      stream
      |> Flow.from_enumerable(max_demand: 20)
      |> Flow.reduce(fn -> [] end, fn(line, acc) ->
        words_count =
          String.split(line, " ")
          |> Enum.count()

        [words_count | acc]
      end)
      |> Enum.reduce(0, &(&1 + &2))

    IO.puts(result)
  end

  def run do
    Benchee.run(%{
      "words" => fn -> words() end,
      "words_flow" => fn -> words_flow() end
    })
  end
end

Words.run()
