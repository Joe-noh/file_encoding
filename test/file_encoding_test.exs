defmodule FileEncodingTest do
  use ExUnit.Case

  @dir "test/test_files/"

  test "UTF-8" do
    assert FileEncoding.judge(@dir <> "utf8.txt") == :utf8
  end

  test "UTF-8 with BOM" do
    assert FileEncoding.judge(@dir <> "utf8-bom.txt") == :utf8
  end

  test "EUC-JP" do
    assert FileEncoding.judge(@dir <> "eucjp.txt") == :eucjp
  end

  test "Shift_JIS" do
    assert FileEncoding.judge(@dir <> "sjis.txt") == :sjis
  end

  test "binary" do
    assert FileEncoding.judge(@dir <> "binary") == :binary
  end

  test "ascii" do
    assert FileEncoding.judge(@dir <> "ascii.txt") == :ascii
  end
end
