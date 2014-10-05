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
end
