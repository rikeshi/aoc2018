import tables, streams, strutils, sequtils, re, algorithm, math

proc read_input(fname: string): seq[string] =
  newFileStream(fname, fmRead)
    .readAll()
    .strip()
    .splitLines()

proc process(
  x: seq[string]
): seq[tuple[min: int, desc: string]] =
  x
  .map(proc(x: string): array[2, string] =
    var m: array[2, string]
    discard find(x, re"\[(.+)\].+(#\d+|falls|wakes)", m)
    m)
  .sorted(proc(a, b: array[2, string]): int =
    cmp(a[0], b[0]))
  .map(proc(x: array[2, string]): tuple[min: int, desc: string] =
    (x[0][^2..^1].parseInt, x[1]))

func count(
  records: seq[tuple[min: int, desc: string]]
): Table[string, seq[int]] =
  var counts = initTable[string, seq[int]]()
  var active = (id: "", asleepsince: 0)

  for rec in records:
    if rec.desc.startswith('#'):
      active.id = rec.desc
    elif rec.desc == "falls":
      active.asleepsince = rec.min
    elif rec.desc == "wakes":
      if not counts.hasKey(active.id):
        counts[active.id] = newSeq[int](60)
      for i in active.asleepsince..rec.min-1:
        counts[active.id][i] += 1
  counts

func findmax(sq: seq[int]): int =
  var maxi = 0
  for i in 1..sq.len-1:
    if sq[i] > sq[maxi]:
      maxi = i
  maxi


let records = process(read_input("input"))
let counts = count(records)

var
  maxsofar = 0
  candidate: string
for k, v in pairs(counts):
  let vsum = v.sum
  if vsum > maxsofar:
    maxsofar = vsum
    candidate = k

let minute = findmax(counts[candidate])
echo candidate[1..^1].parseInt * minute
