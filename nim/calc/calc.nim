# Bevinguts a asquest detector de OSs fet en Nim

# when system.hostOS == "windows":
#   echo "running Windows, really?"
# elif system.hostOS == "linux":
#   echo "Hello, fellow linux user"
# elif system.hostOS == "macosx":
#   echo "Wow, a Mac user"
# else:
#   echo "What you running, mate?"

import strutils
import parseutils

proc suma(x, y: float): float =
 return x + y

proc resta(x, y: float): float =
 return x - y

proc mult(x, y: float): float =
  return x * y

proc divisio(x, y: float): float =
  return x / y

proc parseFloat(s: string; number: var float; start = 0): int {.gcsafe,
    extern: "npuParseFloat", noSideEffect, raises: [], tags: [].}

assert (suma(1, 1) == 2)
assert (resta(1, 1) == 0)
assert (mult(5, 5) == 25)
assert (divisio(10, 2) == 5)
assert (parseFloat("3.1415") == 3.1415)

echo "Esperant\n"
var entrada: string = readLine(stdin)
# echo entrada.split[1]
var s1: string = entrada.split[0]
var s2: string = entrada.split[1]
var s3: string = entrada.split[2]
var f1: float

doAssert parseFloat(s1, f1, 0)
