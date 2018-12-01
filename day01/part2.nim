import sets, streams, strutils, sequtils

proc read_input(fname: string): seq[int] =
  newFileStream(fname, fmRead)
    .readAll()
    .strip()
    .splitLines()
    .map(parseInt)

proc partial_sums(changes: seq[int]): iterator(): int =
  return iterator(): int =
    var psum = 0
    while true:
      for c in changes:
        psum += c
        yield psum

proc first_repetition(sums: iterator(): int): int =
  var
    seen = initSet[int]()
    freq = 0
  while not seen.contains(freq):
    seen.incl(freq)
    freq = sums()
  freq

echo first_repetition(partial_sums(read_input("input")))
