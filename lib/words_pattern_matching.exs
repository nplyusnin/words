defmodule WordsPatternMatching do
  for word_length <- 1..100 do
    def first_word(<<
      word :: binary-size(unquote(word_length)),
      "\s",
      _ :: binary()
    >>), do: %{word: word}
  end
end

IO.inspect(WordsPatternMatching.first_word("foo bar baz"))
IO.inspect(WordsPatternMatching.first_word("fooo "))
IO.inspect(WordsPatternMatching.first_word("foooo "))
IO.inspect(WordsPatternMatching.first_word("fooooo "))
