defmodule FileEncoding.Likelihood do
  defstruct utf8: 0, eucjp: 0, sjis: 0, binary: 0, count: 0

  def like_utf8(lh) do
    %__MODULE__{lh | count: lh.count+1, utf8: lh.utf8+1}
  end

  def like_eucjp(lh) do
    %__MODULE__{lh | count: lh.count+1, eucjp: lh.eucjp + 1}
  end

  def like_sjis(lh) do
    %__MODULE__{lh | count: lh.count+1, sjis: lh.sjis + 1}
  end

  def like_binary(lh) do
    %__MODULE__{lh | count: lh.count+1, binary: lh.binary + 1}
  end

  def most_likely(%__MODULE__{utf8: utf, eucjp: euc, sjis: sjis}) do
    cond do
      utf + euc + sjis == 0 -> :ascii
      utf  >= euc and utf  >= sjis -> :utf8
      euc  >= utf and euc  >= sjis -> :eucjp
      sjis >= utf and sjis >= euc  -> :sjis
      true -> :ascii
    end
  end
end
