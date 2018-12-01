import streams, strutils, sequtils

let ans = foldr(
  newFileStream("input", fmRead)
    .readAll()
    .strip()
    .splitLines()
    .map(parseInt),
  a + b)

echo ans
