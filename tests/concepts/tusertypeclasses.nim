discard """
  output: '''Sortable
Sortable
Container
'''
"""

import typetraits

template reject(expr) = assert(not compiles(x))

type
  TObj = object
    x: int

  Sortable = concept x, y
    (x < y) is bool

  ObjectContainer = concept C
    C.len is Ordinal
    for v in items(C):
      v.type is tuple|object

proc foo(c: ObjectContainer) =
  echo "Container"

proc foo(x: Sortable) =
  echo "Sortable"

foo 10
foo "test"
foo(@[TObj(x: 10), TObj(x: 20)])

proc intval(x: int): int = 10

type
  TFoo = concept o, type T, ref r, var v, ptr p, static s
    o.x
    y(o) is int

    var str: string
    var intref: ref int

    refproc(ref T, ref int)
    varproc(var T)
    ptrproc(ptr T, str)

    staticproc(static[T])

    typeproc o.type
    o.type.typeproc

    refproc(r, intref)
    varproc(v)
    p.ptrproc(string)
    staticproc s
    typeproc(T)

    const TypeName = T.name
    type MappedType = type(T.y)

    intval T.y
    let z = intval(o.y)

    static:
      assert T.name.len == 4
      reject o.name
      reject o.typeproc
      reject staticproc(o)
      reject o.varproc
      reject T.staticproc
      reject p.staticproc

proc y(x: TObj): int = 10

proc varproc(x: var TObj) = discard
proc refproc(x: ref TObj, y: ref int) = discard
proc ptrproc(x: ptr TObj, y: string) = discard
proc staticproc(x: static[TObj]) = discard
proc typeproc(t: type TObj) = discard

proc testFoo(x: TFoo) = discard
testFoo(TObj(x: 10))

