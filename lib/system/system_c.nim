#
#
#            Nim's Runtime Library
#        (c) Copyright 2019 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#


# This is an iclude file to be used for C backend.
# It implies `when not defined(JS)`.



when not defined(nimSeqsV2):
  type
    TGenericSeq {.compilerproc, pure, inheritable.} = object
      len, reserved: int
      when defined(gogc):
        elemSize: int
    PGenericSeq {.exportc.} = ptr TGenericSeq
    # len and space without counting the terminating zero:
    NimStringDesc {.compilerproc, final.} = object of TGenericSeq
      data: UncheckedArray[char]
    NimString = ptr NimStringDesc


when not defined(nimscript):
  when not defined(nimSeqsV2):
    template space(s: PGenericSeq): int {.dirty.} =
      s.reserved and not (seqShallowFlag or strlitFlag)
  when not defined(nimV2):
    include "system/hti"


proc newSeqUninitialized*[T: SomeNumber](len: Natural): seq[T] =
  ## Creates a new sequence of type ``seq[T]`` with length ``len``.
  ##
  ## Only available for numbers types. Note that the sequence will be
  ## uninitialized. After the creation of the sequence you should assign
  ## entries to the sequence instead of adding them.
  ##
  ## .. code-block:: Nim
  ##   var x = newSeqUninitialized[int](3)
  ##   assert len(x) == 3
  ##   x[0] = 10
  result = newSeqOfCap[T](len)
  when defined(nimSeqsV2):
    cast[ptr int](addr result)[] = len
  else:
    var s = cast[PGenericSeq](result)
    s.len = len



# --------------------------------------------------------------------------
# built-in operators
when defined(nimNoZeroExtendMagic):
  proc ze*(x: int8): int {.deprecated.} =
    ## zero extends a smaller integer type to ``int``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

    cast[int](uint(cast[uint8](x)))

  proc ze*(x: int16): int {.deprecated.} =
    ## zero extends a smaller integer type to ``int``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int](uint(cast[uint16](x)))

  proc ze64*(x: int8): int64 {.deprecated.} =
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int64](uint64(cast[uint8](x)))

  proc ze64*(x: int16): int64 {.deprecated.} =
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int64](uint64(cast[uint16](x)))

  proc ze64*(x: int32): int64 {.deprecated.} =
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int64](uint64(cast[uint32](x)))

  proc ze64*(x: int): int64 {.deprecated.} =
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned. Does nothing if the size of an ``int`` is the same as ``int64``.
    ## (This is the case on 64 bit processors.)
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int64](uint64(cast[uint](x)))

  proc toU8*(x: int): int8 {.deprecated.} =
    ## treats `x` as unsigned and converts it to a byte by taking the last 8 bits
    ## from `x`.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int8](x)

  proc toU16*(x: int): int16 {.deprecated.} =
    ## treats `x` as unsigned and converts it to an ``int16`` by taking the last
    ## 16 bits from `x`.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int16](x)

  proc toU32*(x: int64): int32 {.deprecated.} =
    ## treats `x` as unsigned and converts it to an ``int32`` by taking the
    ## last 32 bits from `x`.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.
    cast[int32](x)

else:
  proc ze*(x: int8): int {.magic: "Ze8ToI", noSideEffect, deprecated.}
    ## zero extends a smaller integer type to ``int``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc ze*(x: int16): int {.magic: "Ze16ToI", noSideEffect, deprecated.}
    ## zero extends a smaller integer type to ``int``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc ze64*(x: int8): int64 {.magic: "Ze8ToI64", noSideEffect, deprecated.}
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc ze64*(x: int16): int64 {.magic: "Ze16ToI64", noSideEffect, deprecated.}
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc ze64*(x: int32): int64 {.magic: "Ze32ToI64", noSideEffect, deprecated.}
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc ze64*(x: int): int64 {.magic: "ZeIToI64", noSideEffect, deprecated.}
    ## zero extends a smaller integer type to ``int64``. This treats `x` as
    ## unsigned. Does nothing if the size of an ``int`` is the same as ``int64``.
    ## (This is the case on 64 bit processors.)
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc toU8*(x: int): int8 {.magic: "ToU8", noSideEffect, deprecated.}
    ## treats `x` as unsigned and converts it to a byte by taking the last 8 bits
    ## from `x`.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc toU16*(x: int): int16 {.magic: "ToU16", noSideEffect, deprecated.}
    ## treats `x` as unsigned and converts it to an ``int16`` by taking the last
    ## 16 bits from `x`.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.

  proc toU32*(x: int64): int32 {.magic: "ToU32", noSideEffect, deprecated.}
    ## treats `x` as unsigned and converts it to an ``int32`` by taking the
    ## last 32 bits from `x`.
    ## **Deprecated since version 0.19.9**: Use unsigned integers instead.


when hostOS != "standalone":
  var programResult* {.compilerproc, exportc: "nim_program_result".}: int
    ## deprecated, prefer ``quit``


when not defined(nimscript) and hostOS != "standalone":
  include "system/cgprocs"
when not defined(nimscript) and hasAlloc and not defined(nimSeqsV2):
  proc addChar(s: NimString, c: char): NimString {.compilerproc, benign.}


type BiggestUInt* = uint64
  ## is an alias for the biggest unsigned integer type the Nim compiler
  ## supports. Currently this is ``uint32`` for JS and ``uint64`` for other
  ## targets.


when not defined(booting) and defined(nimTrMacros):
  template swapRefsInArray*{swap(arr[a], arr[b])}(arr: openArray[ref], a, b: int) =
    # Optimize swapping of array elements if they are refs. Default swap
    # implementation will cause unsureAsgnRef to be emitted which causes
    # unnecessary slow down in this case.
    swap(cast[ptr pointer](addr arr[a])[], cast[ptr pointer](addr arr[b])[])


when not defined(nimscript):
  {.push stackTrace: off, profiler:off.}

  proc atomicInc*(memLoc: var int, x: int = 1): int {.inline,
    discardable, benign.}
    ## Atomic increment of `memLoc`. Returns the value after the operation.

  proc atomicDec*(memLoc: var int, x: int = 1): int {.inline,
    discardable, benign.}
    ## Atomic decrement of `memLoc`. Returns the value after the operation.

  include "system/atomics"

  {.pop.}



when hasAlloc:
  {.push stack_trace:off, profiler:off.}
  proc add*(x: var string, y: cstring) =
    var i = 0
    while y[i] != '\0':
      add(x, y[i])
      inc(i)
  {.pop.}



proc likelyProc(val: bool): bool {.importc: "NIM_LIKELY", nodecl, noSideEffect.}
proc unlikelyProc(val: bool): bool {.importc: "NIM_UNLIKELY", nodecl, noSideEffect.}




{.push stack_trace: off, profiler:off.}

when hasAlloc:
  when not defined(gcRegions) and not usesDestructors:
    proc initGC() {.gcsafe.}

  proc initStackBottom() {.inline, compilerproc.} =
    # WARNING: This is very fragile! An array size of 8 does not work on my
    # Linux 64bit system. -- That's because the stack direction is the other
    # way around.
    when declared(nimGC_setStackBottom):
      var locals {.volatile.}: pointer
      locals = addr(locals)
      nimGC_setStackBottom(locals)

  proc initStackBottomWith(locals: pointer) {.inline, compilerproc.} =
    # We need to keep initStackBottom around for now to avoid
    # bootstrapping problems.
    when declared(nimGC_setStackBottom):
      nimGC_setStackBottom(locals)

  when not usesDestructors:
    {.push profiler: off.}
    var
      strDesc = TNimType(size: sizeof(string), kind: tyString, flags: {ntfAcyclic})
    {.pop.}

when not defined(nimscript):
  proc zeroMem(p: pointer, size: Natural) =
    nimZeroMem(p, size)
    when declared(memTrackerOp):
      memTrackerOp("zeroMem", p, size)
  proc copyMem(dest, source: pointer, size: Natural) =
    nimCopyMem(dest, source, size)
    when declared(memTrackerOp):
      memTrackerOp("copyMem", dest, size)
  proc moveMem(dest, source: pointer, size: Natural) =
    c_memmove(dest, source, csize_t(size))
    when declared(memTrackerOp):
      memTrackerOp("moveMem", dest, size)
  proc equalMem(a, b: pointer, size: Natural): bool =
    nimCmpMem(a, b, size) == 0

proc cmp(x, y: string): int =
  when defined(nimscript):
    if x < y: result = -1
    elif x > y: result = 1
    else: result = 0
  else:
    when nimvm:
      if x < y: result = -1
      elif x > y: result = 1
      else: result = 0
    else:
      let minlen = min(x.len, y.len)
      result = int(nimCmpMem(x.cstring, y.cstring, cast[csize_t](minlen)))
      if result == 0:
        result = x.len - y.len

when declared(newSeq):
  proc cstringArrayToSeq*(a: cstringArray, len: Natural): seq[string] =
    ## Converts a ``cstringArray`` to a ``seq[string]``. `a` is supposed to be
    ## of length ``len``.
    newSeq(result, len)
    for i in 0..len-1: result[i] = $a[i]

  proc cstringArrayToSeq*(a: cstringArray): seq[string] =
    ## Converts a ``cstringArray`` to a ``seq[string]``. `a` is supposed to be
    ## terminated by ``nil``.
    var L = 0
    while a[L] != nil: inc(L)
    result = cstringArrayToSeq(a, L)

# -------------------------------------------------------------------------

when declared(alloc0) and declared(dealloc):
  proc allocCStringArray*(a: openArray[string]): cstringArray =
    ## Creates a NULL terminated cstringArray from `a`. The result has to
    ## be freed with `deallocCStringArray` after it's not needed anymore.
    result = cast[cstringArray](alloc0((a.len+1) * sizeof(cstring)))

    let x = cast[ptr UncheckedArray[string]](a)
    for i in 0 .. a.high:
      result[i] = cast[cstring](alloc0(x[i].len+1))
      copyMem(result[i], addr(x[i][0]), x[i].len)

  proc deallocCStringArray*(a: cstringArray) =
    ## Frees a NULL terminated cstringArray.
    var i = 0
    while a[i] != nil:
      dealloc(a[i])
      inc(i)
    dealloc(a)

when not defined(nimscript):
  type
    PSafePoint = ptr TSafePoint
    TSafePoint {.compilerproc, final.} = object
      prev: PSafePoint # points to next safe point ON THE STACK
      status: int
      context: C_JmpBuf
      hasRaiseAction: bool
      raiseAction: proc (e: ref Exception): bool {.closure.}
    SafePoint = TSafePoint

when declared(initAllocator):
  initAllocator()
when hasThreadSupport:
  when hostOS != "standalone": include "system/threads"
elif not defined(nogc) and not defined(nimscript):
  when not defined(useNimRtl) and not defined(createNimRtl): initStackBottom()
  when declared(initGC): initGC()

when not defined(nimscript):
  proc setControlCHook*(hook: proc () {.noconv.})
    ## Allows you to override the behaviour of your application when CTRL+C
    ## is pressed. Only one such hook is supported.

  when not defined(noSignalHandler) and not defined(useNimRtl):
    proc unsetControlCHook*()
      ## Reverts a call to setControlCHook.

  proc writeStackTrace*() {.tags: [], gcsafe.}
    ## Writes the current stack trace to ``stderr``. This is only works
    ## for debug builds. Since it's usually used for debugging, this
    ## is proclaimed to have no IO effect!
  when hostOS != "standalone":
    proc getStackTrace*(): string {.gcsafe.}
      ## Gets the current stack trace. This only works for debug builds.

    proc getStackTrace*(e: ref Exception): string {.gcsafe.}
      ## Gets the stack trace associated with `e`, which is the stack that
      ## lead to the ``raise`` statement. This only works for debug builds.

  {.push stackTrace: off, profiler:off.}
  when defined(memtracker):
    include "system/memtracker"

  when hostOS == "standalone":
    include "system/embedded"
  else:
    include "system/excpt"
  include "system/chcks"

  # we cannot compile this with stack tracing on
  # as it would recurse endlessly!
  include "system/arithm"
  {.pop.} # stack trace
{.pop.} # stack trace

when hostOS != "standalone" and not defined(nimscript):
  include "system/dyncalls"
when not defined(nimscript):
  include "system/sets"

  when defined(gogc):
    const GenericSeqSize = (3 * sizeof(int))
  else:
    const GenericSeqSize = (2 * sizeof(int))

  when not defined(nimV2):
    proc getDiscriminant(aa: pointer, n: ptr TNimNode): uint =
      sysAssert(n.kind == nkCase, "getDiscriminant: node != nkCase")
      var d: uint
      var a = cast[uint](aa)
      case n.typ.size
      of 1: d = uint(cast[ptr uint8](a + uint(n.offset))[])
      of 2: d = uint(cast[ptr uint16](a + uint(n.offset))[])
      of 4: d = uint(cast[ptr uint32](a + uint(n.offset))[])
      of 8: d = uint(cast[ptr uint64](a + uint(n.offset))[])
      else: sysAssert(false, "getDiscriminant: invalid n.typ.size")
      return d

    proc selectBranch(aa: pointer, n: ptr TNimNode): ptr TNimNode =
      var discr = getDiscriminant(aa, n)
      if discr < cast[uint](n.len):
        result = n.sons[discr]
        if result == nil: result = n.sons[n.len]
        # n.sons[n.len] contains the ``else`` part (but may be nil)
      else:
        result = n.sons[n.len]

  {.push profiler:off.}
  when hasAlloc: include "system/mmdisp"
  {.pop.}
  {.push stack_trace: off, profiler:off.}
  when hasAlloc:
    when not defined(nimSeqsV2):
      include "system/sysstr"
  {.pop.}
  when hasAlloc: include "system/strmantle"

  when hasThreadSupport:
    when hostOS != "standalone" and not usesDestructors: include "system/channels"

when not defined(nimscript) and hasAlloc:
  when not usesDestructors:
    include "system/assign"
  when not defined(nimV2):
    include "system/repr"

when hostOS != "standalone" and not defined(nimscript):
  proc getCurrentException*(): ref Exception {.compilerRtl, inl, benign.} =
    ## Retrieves the current exception; if there is none, `nil` is returned.
    result = currException

  proc getCurrentExceptionMsg*(): string {.inline, benign.} =
    ## Retrieves the error message that was attached to the current
    ## exception; if there is none, `""` is returned.
    var e = getCurrentException()
    return if e == nil: "" else: e.msg

  proc setCurrentException*(exc: ref Exception) {.inline, benign.} =
    ## Sets the current exception.
    ##
    ## **Warning**: Only use this if you know what you are doing.
    currException = exc

{.push stack_trace: off, profiler:off.}
when (defined(profiler) or defined(memProfiler)) and not defined(nimscript):
  include "system/profiler"
{.pop.} # stacktrace

when not defined(nimscript):
  proc rawProc*[T: proc](x: T): pointer {.noSideEffect, inline.} =
    ## Retrieves the raw proc pointer of the closure `x`. This is
    ## useful for interfacing closures with C.
    {.emit: """
    `result` = `x`.ClP_0;
    """.}

  proc rawEnv*[T: proc](x: T): pointer {.noSideEffect, inline.} =
    ## Retrieves the raw environment pointer of the closure `x`. This is
    ## useful for interfacing closures with C.
    {.emit: """
    `result` = `x`.ClE_0;
    """.}

  proc finished*[T: proc](x: T): bool {.noSideEffect, inline.} =
    ## can be used to determine if a first class iterator has finished.
    {.emit: """
    `result` = ((NI*) `x`.ClE_0)[1] < 0;
    """.}

{.pop.} # checks
{.pop.} # hints



when hasAlloc and not defined(nimscript) and not usesDestructors:
  # XXX how to implement 'deepCopy' is an open problem.
  proc deepCopy*[T](x: var T, y: T) {.noSideEffect, magic: "DeepCopy".} =
    ## Performs a deep copy of `y` and copies it into `x`.
    ##
    ## This is also used by the code generator
    ## for the implementation of ``spawn``.
    discard

  proc deepCopy*[T](y: T): T =
    ## Convenience wrapper around `deepCopy` overload.
    deepCopy(result, y)

  include "system/deepcopy"


proc toOpenArray*[T](x: ptr UncheckedArray[T]; first, last: int): openArray[T] {.
  magic: "Slice".}
when defined(nimToOpenArrayCString):
  proc toOpenArray*(x: cstring; first, last: int): openArray[char] {.
    magic: "Slice".}
  proc toOpenArrayByte*(x: cstring; first, last: int): openArray[byte] {.
    magic: "Slice".}
