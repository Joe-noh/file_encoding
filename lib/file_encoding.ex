defmodule FileEncoding do
  alias FileEncoding.Likelihood

  def judge(filepath) do
    filepath
    |> File.open!([:raw, :read])
    |> IO.binread(256)
    |> judge(%Likelihood{})
    |> most_likely
  end

  defp judge("", likelihood) do
    likelihood
  end

  # empty file
  defp judge(:eof, _) do
    :ascii
  end

  # UTF-8 with BOM
  defp judge(<<0xEF, 0xBB, 0xBF, _ :: binary>>, _) do
    :utf8
  end

  # PNG
  defp judge(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _ :: binary>>, _) do
    :binary
  end

  # PDF
  defp judge(<<0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, b, _ :: binary>>, _) when
  (0x30 <= b and b <= 0x37) do
    :binary
  end

  defp judge(bytes = <<b, rest :: binary>>, likelihood) do
    cond do
      b == 0x00 ->
        :binary
      likelihood.count >= 32 and likelihood.binary > 0.1*length(bytes) ->
        :binary
      (b < 0x07 or 0x0E < b) and (b < 0x20 or 0x7F < b) ->
        check_utf8_likelihood(bytes, likelihood)
      true ->
        judge(rest, likelihood)
    end
  end

  # UTF-8

  defp check_utf8_likelihood(<<>>, likelihood) do
    likelihood
  end

  defp check_utf8_likelihood(<<b1, b2, rest :: binary>>, likelihood) when
  0xC1 < b1 and b1 < 0xE0 and 0x7F < b2 and b2 < 0xC0 do
    check_utf8_likelihood(rest, Likelihood.like_utf8(likelihood))
  end

  defp check_utf8_likelihood(<<b1, b2, rest :: binary>>, likelihood) when
  0xC1 < b1 and b1 < 0xE0 do
    check_eucjp_likelihood(<<b2>> <> rest, likelihood)
  end

  defp check_utf8_likelihood(<<b1, b2, b3, rest :: binary>>, likelihood) when
  0xDF < b1 and b1 < 0xF0 and 0x7F < b2 and b2 < 0xC0 and 0x7F < b3 and b3 < 0xC0 do
    check_utf8_likelihood(rest, Likelihood.like_utf8(likelihood))
  end

  defp check_utf8_likelihood(<<b1, b2, b3, rest :: binary>>, likelihood) when
  0xDF < b1 and b1 < 0xF0 do
    check_eucjp_likelihood(<<b2, b3>> <> rest, likelihood)
  end

  defp check_utf8_likelihood(bytes, likelihood) do
    check_eucjp_likelihood(bytes, likelihood)
  end

  # EUC-JP

  defp check_eucjp_likelihood(<<>>, likelihood) do
    likelihood
  end

  defp check_eucjp_likelihood(<<0x8E, b2, rest :: binary>>, likelihood) when
  0xA0 < b2 and b2 < 0xE0 do
    check_utf8_likelihood(rest, Likelihood.like_eucjp(likelihood))
  end

  defp check_eucjp_likelihood(<<0x8E, b2, rest :: binary>>, likelihood) do
    check_sjis_likelihood(<<b2>> <> rest, likelihood)
  end

  defp check_eucjp_likelihood(<<b1, b2, rest :: binary>>, likelihood) when
  0xA0 < b1 and b1 < 0xFF and 0xA0 < b2 and b2 < 0xFF do
    check_utf8_likelihood(rest, Likelihood.like_eucjp(likelihood))
  end

  defp check_eucjp_likelihood(<<b1, b2, rest :: binary>>, likelihood) when
  0xA0 < b1 and b1 < 0xFF do
    check_sjis_likelihood(<<b2>> <> rest, likelihood)
  end

  defp check_eucjp_likelihood(bytes, likelihood) do
    check_sjis_likelihood(bytes, likelihood)
  end

  # SHIFT-JIS

  defp check_sjis_likelihood(<<>>, likelihood) do
    likelihood
  end

  defp check_sjis_likelihood(<<b1, rest :: binary>>, likelihood) when
  0xA0 < b1 and b1 < 0xE0 do
    check_utf8_likelihood(rest, Likelihood.like_sjis(likelihood))
  end

  defp check_sjis_likelihood(<<b1, b2, rest :: binary>>, likelihood) when
  ((0x80 < b1 and b1 < 0xA0) or (0xDF < b1 and b1 < 0xF0)) and
  ((0x3F < b2 and b2 < 0x7F) or (0x7F < b2 and b2 < 0xFD)) do
    check_utf8_likelihood(rest, Likelihood.like_sjis(likelihood))
  end

  defp check_sjis_likelihood(<<b1, _b2, rest :: binary>>, likelihood) when
  (0x80 < b1 and b1 < 0xA0) or (0xDF < b1 and b1 < 0xF0) do
    suspicious_byte(rest, Likelihood.like_sjis(likelihood))
  end

  defp check_sjis_likelihood(bytes, likelihood) do
    suspicious_byte(bytes, likelihood)
  end

  defp suspicious_byte(<<_b1, rest :: binary>>, likelihood) do
    check_utf8_likelihood(rest, Likelihood.like_binary(likelihood))
  end

  defp most_likely(encoding) when is_atom(encoding) do
    encoding
  end

  defp most_likely(likelihood = %Likelihood{}) do
    Likelihood.most_likely(likelihood)
  end
end
