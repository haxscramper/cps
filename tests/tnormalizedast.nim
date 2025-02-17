import balls
import cps/normalizedast

import std/[macros, genasts]

# these tests were initially motivated because the normalizedast was not
# forgiving enough for various return types.

macro checkType(s: untyped): untyped =
  ## checks if a type is a valid type expression
  let
    n = s[0][0][2] # unwrap as it's nnkStmtList > nnkTypeSection > nnkTypeDef
    r = NimNode asTypeExpr(NormNode n)
    isError = r.kind == nnkError # did it work?

    # test output parts
    rep = if isError: treeRepr(n) else: repr(n)
    msgPrefix = if isError: "valid" else: "invalid"
    checkStatus = not isError
    msg = msgPrefix & " type expression: " & rep
  
  result = genast(checkStatus, msg):
    check checkStatus, msg

suite "normalizedast tests to quickly test APIs":
  # the expectation is that these tests can easily be changed if in the way

  block:
    ## tuple type expressions (nnkTupleConstr)
    checkType:
      type Foo = (int, string)

  block:
    ## seq type expressions (nnkBracketExpr)
    checkType:
      type Foo = seq[int]

  block:
    ## seq type expressions (nnkProcTy)
    checkType:
      type Foo = proc (i: int): int
