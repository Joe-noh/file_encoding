# FileEncoding

## Usage

```elixir
FileEncoding.judge "utf8.txt"   #=> :utf8
FileEncoding.judge "eucjp.txt"  #=> :eucjp
FileEncoding.judge "sjis.txt"   #=> :sjis
FileEncoding.judge "ascii.txt"  #=> :ascii
FileEncoding.judge "binary"     #=> :binary
```
