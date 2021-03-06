#
#
#            Nim's Runtime Library
#        (c) Copyright 2015 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## This module contains code for reading from `stdin`:idx:. On UNIX the
## linenoise library is wrapped and set up to provide default key bindings
## (e.g. you can navigate with the arrow keys). On Windows ``system.readLine``
## is used. This suffices because Windows' console already provides the
## wanted functionality.

{.deadCodeElim: on.}  # dce option deprecated

when defined(Windows):
  proc readLineFromStdin*(prompt: string): TaintedString {.
                          tags: [ReadIOEffect, WriteIOEffect].} =
    ## Reads a line from stdin.
    stdout.write(prompt)
    result = readLine(stdin)

  proc readLineFromStdin*(prompt: string, line: var TaintedString): bool {.
                          tags: [ReadIOEffect, WriteIOEffect].} =
    ## Reads a `line` from stdin. `line` must not be
    ## ``nil``! May throw an IO exception.
    ## A line of text may be delimited by ``CR``, ``LF`` or
    ## ``CRLF``. The newline character(s) are not part of the returned string.
    ## Returns ``false`` if the end of the file has been reached, ``true``
    ## otherwise. If ``false`` is returned `line` contains no new data.
    stdout.write(prompt)
    result = readLine(stdin, line)

elif defined(genode):
  proc readLineFromStdin*(prompt: string): TaintedString {.
                          tags: [ReadIOEffect, WriteIOEffect].} =
    stdin.readLine()

  proc readLineFromStdin*(prompt: string, line: var TaintedString): bool {.
                          tags: [ReadIOEffect, WriteIOEffect].} =
    stdin.readLine(line)

else:
  import linenoise, termios

  proc readLineFromStdin*(prompt: string): TaintedString {.
                          tags: [ReadIOEffect, WriteIOEffect].} =
    var buffer = linenoise.readLine(prompt)
    if isNil(buffer):
      raise newException(IOError, "Linenoise returned nil")
    result = TaintedString($buffer)
    if result.string.len > 0:
      historyAdd(buffer)
    linenoise.free(buffer)

  proc readLineFromStdin*(prompt: string, line: var TaintedString): bool {.
                          tags: [ReadIOEffect, WriteIOEffect].} =
    var buffer = linenoise.readLine(prompt)
    if isNil(buffer):
      line.string.setLen(0)
      return false
    line = TaintedString($buffer)
    if line.string.len > 0:
      historyAdd(buffer)
    linenoise.free(buffer)
    result = true

