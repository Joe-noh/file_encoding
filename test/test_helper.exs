ExUnit.start()

defmodule TestHelper do
  defmacro assert_encoding(filename, expected) do
    quote do
      assert FileEncoding.judge("test/test_files/" <> unquote(filename)) == unquote(expected)
    end
  end
end
