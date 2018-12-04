import tables, streams, strutils, sequtils

proc read_input(fname: string): seq[string] =
  newFileStream(fname, fmRead)
    .readAll()
    .strip()
    .splitLines()

proc find_common(ids: seq[string]): string =
  for id1 in ids:
    for id2 in ids:
      var pos, count: int
      for i in 0..id1.len-1:
        if id1[i] != id2[i]:
          count += 1
          pos = i
      if count == 1:
        return id1[0..pos-1] & id1[pos+1..id1.len-1]

echo find_common(read_input("input"))
