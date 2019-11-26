#
#
#            Nim's Runtime Library
#        (c) Copyright 2019 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

# This is an iclude file to be used for JS backend.
# It implies `when defined(JS)`.




when defined(nodejs) and not defined(nimscript):
  var programResult* {.importc: "process.exitCode".}: int
  programResult = 0

type BiggestUInt* = uint32
  ## is an alias for the biggest unsigned integer type the Nim compiler
  ## supports. Currently this is ``uint32`` for JS and ``uint64`` for other
  ## targets.


when defined(nimdoc):
  type
    JsRoot* = ref object of RootObj
      ## Root type of the JavaScript object hierarchy

proc add*(x: var string, y: cstring) {.asmNoStackFrame.} =
  asm """
    if (`x` === null) { `x` = []; }
    var off = `x`.length;
    `x`.length += `y`.length;
    for (var i = 0; i < `y`.length; ++i) {
      `x`[off+i] = `y`.charCodeAt(i);
    }
  """
proc add*(x: var cstring, y: cstring) {.magic: "AppendStrStr".}



{.push stack_trace: off, profiler:off.}
# Stubs:
proc getOccupiedMem(): int = return -1
proc getFreeMem(): int = return -1
proc getTotalMem(): int = return -1

proc dealloc(p: pointer) = discard
proc alloc(size: Natural): pointer = discard
proc alloc0(size: Natural): pointer = discard
proc realloc(p: pointer, newsize: Natural): pointer = discard

proc allocShared(size: Natural): pointer = discard
proc allocShared0(size: Natural): pointer = discard
proc deallocShared(p: pointer) = discard
proc reallocShared(p: pointer, newsize: Natural): pointer = discard

proc addInt*(result: var string; x: int64) =
  result.add $x

proc addFloat*(result: var string; x: float) =
  result.add $x

when defined(JS) and not defined(nimscript):
  include "system/jssys"
  include "system/reprjs"
elif defined(nimscript):
  proc cmp(x, y: string): int =
    if x == y: return 0
    if x < y: return -1
    return 1
{.pop.} # checks ??
