defmodule Words do
  def words do
    stream = File.stream!("./data/lorem")

    result =
      Enum.reduce(stream, 0, fn(line, acc) ->
        line
        |> String.split(" ")
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
          line
          |> String.split(" ")
          |> Enum.count()

        [words_count | acc]
      end)
      |> Enum.reduce(0, &(&1 + &2))

    IO.puts(result)
  end

  def words_flow_pattern_matching do
    stream = File.stream!("./data/lorem")

    result =
      stream
      |> Flow.from_enumerable(max_demand: 20)
      |> Flow.reduce(fn -> [] end, fn(line, acc) ->
        words_count = parse(line, 1)

        [words_count | acc]
      end)
      |> Enum.reduce(0, &(&1 + &2))

    IO.puts(result)
  end

  def parse("", acc), do: acc
  for word_length <- 1..100 do
    def parse(<<
      word :: binary-size(unquote(word_length)),
      "\s",
      rest :: binary(),
    >>, acc) do
      parse(rest, acc + 1)
    end
  end
  def parse(rest, acc), do: acc

  def run do
    Benchee.run(%{
      "words" => fn -> words() end,
      "words_flow" => fn -> words_flow() end,
      "words_flow_pattern_matching" => fn -> words_flow_pattern_matching() end
    })
  end
end

Words.run()
# IO.inspect(Words.parse("foo bar baz foo bar baz foo bar baz", 1))
