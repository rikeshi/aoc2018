import tables, streams, strutils, sequtils

proc read_input(fname: string): seq[string] =
  newFileStream(fname, fmRead)
    .readAll()
    .strip()
    .splitLines()

proc count_chars(idstr: string): Table[char, int] =
  var occ = initTable[char, int]()
  for ch in idstr:
    occ[ch] = getOrDefault(occ, ch) + 1
  occ

proc check_n(occ: Table[char, int], n: int): int =
  for v in values(occ):
    if v == n:
      return 1
  0

var count2, count3: int
for id in read_input("input"):
  let occ = count_chars(id)
  count2 += check_n(occ, 2)
  count3 += check_n(occ, 3)

echo count2 * count3
