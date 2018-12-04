import streams, strutils, sequtils, re

proc read_input(
  fname: string
): seq[tuple[id: string, x, y, w, h: int]] =
  map(
    newFileStream(fname, fmRead)
      .readAll()
      .strip()
      .splitLines(),
    proc(s: string): tuple[id: string, x, y, w, h: int] =
      var m: array[5, string]
      discard find(s, re"(#\d+) @ (\d+),(\d+): (\d+)x(\d+)$", m)
      (m[0],
       m[1].parseInt,
       m[2].parseInt,
       m[3].parseInt,
       m[4].parseInt))

proc bbox(
  rects: seq[tuple[id: string, x, y, w, h: int]]
): tuple[w, h: int] =
  var
    xlo, ylo = high(int)
    xhi, yhi = low(int)
  for r in rects:
    if r.x < xlo:
      xlo = r.x
    elif r.y < ylo:
      ylo = r.y
    elif r.x + r.w > xhi:
      xhi = r.x + r.w
    elif r.y + r.h > yhi:
      yhi = r.y + r.h
  (xhi, yhi)

proc add_rect(
  bb: tuple[w, h: int],
  area: var seq[int],
  r: tuple[id: string, x, y, w, h: int]
) =
  for y in r.y..r.y+r.h-1:
    for x in r.x..r.x+r.w-1:
      let i = y * bb.w + x
      area[i] += 1

let rects = read_input("input")
let bb = bbox(rects)
var area = newSeq[int](bb.w * bb.h)

for r in rects:
  add_rect(bb, area, r)

var overlap: int
for i in 0..area.len-1:
  if area[i] > 1:
    overlap += 1

for r in rects:
  var nope = false
  block rloop:
    for y in r.y..r.y+r.h-1:
      for x in r.x..r.x+r.w-1:
        let i = y * bb.w + x
        if area[i] > 1:
          nope = true
          break rloop
  if not nope:
    echo r.id
    break
