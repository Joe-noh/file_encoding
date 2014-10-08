defmodule FileEncodingTest do
  use ExUnit.Case

  import TestHelper

  test "UTF-8" do
    assert_encoding("utf8.txt", :utf8)
  end

  test "UTF-8 with BOM" do
    assert_encoding("utf8-bom.txt", :utf8)
  end

  test "EUC-JP" do
    assert_encoding("eucjp.txt", :eucjp)
  end

  test "Shift_JIS" do
    assert_encoding("sjis.txt", :sjis)
  end

  test "binary" do
    assert_encoding("binary", :binary)
  end

  test "ascii" do
    assert_encoding("ascii.txt", :ascii)
  end

  test "png" do
    assert_encoding("picture.png", :binary)
  end

  test "pdf" do
    assert_encoding("sample.pdf", :binary)
  end

  test "empty file" do
    assert_encoding("empty.txt", :ascii)
  end

  test "when path of file which doesn't exist is given" do
    assert_raise File.Error, fn ->
      FileEncoding.judge! "does_not_exist.txt"
    end

    assert {:error, :enoent} = FileEncoding.judge("does_not_exist.txt")
  end
end
