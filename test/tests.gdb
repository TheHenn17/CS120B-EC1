# Test file for "EC1"


# commands.gdb provides the following functions for ease:
#   test "<message>"
#       Where <message> is the message to print. Must call this at the beginning of every test
#       Example: test "PINA: 0x00 => expect PORTC: 0x01"
#   checkResult
#       Verify if the test passed or failed. Prints "passed." or "failed." accordingly, 
#       Must call this at the end of every test.
#   expectPORTx <val>
#       With x as the port (A,B,C,D)
#       The value the port is epected to have. If not it will print the erroneous actual value
#   setPINx <val>
#       With x as the port or pin (A,B,C,D)
#       The value to set the pin to (can be decimal or hexidecimal
#       Example: setPINA 0x01
#   printPORTx f OR printPINx f 
#       With x as the port or pin (A,B,C,D)
#       With f as a format option which can be: [d] decimal, [x] hexadecmial (default), [t] binary 
#       Example: printPORTC d
#   printDDRx
#       With x as the DDR (A,B,C,D)
#       Example: printDDRB

echo ======================================================\n
echo Running all tests..."\n\n

test "Floor 1 -> 3"
set state = Open
set floor = 0x01

setPINA 0x40
continue 2
expectPORTB 0x00
expect state FinishClose
expect floor 0x01

setPINA 0x00
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x01

setPINA 0x01
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x01

setPINA 0x04
continue 2
expectPORTB 0x64
expect state WaitZero
expect floor 0x01

setPINA 0x00
continue 2
expectPORTB 0x64
expect state WaitComplete
expect floor 0x01

setPINA 0x80
continue 2
expectPORTB 0x64
expect state FinishComplete
expect floor 0x01

setPINA 0x00
continue 2
expectPORTB 0x64
expect state WaitComplete
expect floor 0x02

setPINA 0x80
continue 2
expectPORTB 0x64
expect state FinishComplete
expect floor 0x02

setPINA 0x00
continue 2
expectPORTB 0x00
expect state Open
expect floor 0x04

checkResult

test "Floor 5 -> 3"
set state = Open
set floor = 0x10

setPINA 0x40
continue 2
expectPORTB 0x00
expect state FinishClose
expect floor 0x10

setPINA 0x00
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x10

setPINA 0x10
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x10

setPINA 0x04
continue 2
expectPORTB 0xA4
expect state WaitZero
expect floor 0x10

setPINA 0x00
continue 2
expectPORTB 0xA4
expect state WaitComplete
expect floor 0x10

setPINA 0x80
continue 2
expectPORTB 0xA4
expect state FinishComplete
expect floor 0x10

setPINA 0x00
continue 2
expectPORTB 0xA4
expect state WaitComplete
expect floor 0x08

setPINA 0x80
continue 2
expectPORTB 0xA4
expect state FinishComplete
expect floor 0x08

setPINA 0x00
continue 2
expectPORTB 0x00
expect state Open
expect floor 0x04

checkResult

test "More than two buttons with closed door --> nothing happens"
set state = Closed
set floor = 0x80

setPINA 0x05
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x80

setPINA 0x06
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x80

setPINA 0x03
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x80

setPINA 0x18
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x80

setPINA 0x07
continue 2
expectPORTB 0x20
expect state Closed
expect floor 0x80

checkResult

test "buttons while door open --> nothing happens"
set state = Open
set floor = 0x02

setPINA 0x01
continue 2
expectPORTB 0x20
expect state Open
expect floor 0x02

setPINA 0x02
continue 2
expectPORTB 0x20
expect state Open
expect floor 0x02

setPINA 0x04
continue 2
expectPORTB 0x20
expect state Open
expect floor 0x02

setPINA 0x08
continue 2
expectPORTB 0x20
expect state Open
expect floor 0x02

setPINA 0x10
continue 2
expectPORTB 0x20
expect state Open
expect floor 0x02

checkResult

test "Correct button lights + WaitZero Transition"
set state = Closed
set floor = 0x80

setPINA 0x01
continue 2
expectPORTB 0xA1
expect state WaitZero
expect floor 0x80

set state = Closed
set floor = 0x80

setPINA 0x02
continue 2
expectPORTB 0xA2
expect state WaitZero
expect floor 0x80

set state = Closed
set floor = 0x01

setPINA 0x02
continue 2
expectPORTB 0x62
expect state WaitZero
expect floor 0x01

set state = Closed
set floor = 0x80

setPINA 0x04
continue 2
expectPORTB 0xA4
expect state WaitZero
expect floor 0x80

set state = Closed
set floor = 0x01

setPINA 0x04
continue 2
expectPORTB 0x64
expect state WaitZero
expect floor 0x01

set state = Closed
set floor = 0x10

setPINA 0x08
continue 2
expectPORTB 0xA8
expect state WaitZero
expect floor 0x10

set state = Closed
set floor = 0x01

setPINA 0x08
continue 2
expectPORTB 0x68
expect state WaitZero
expect floor 0x01

set state = Closed
set floor = 0x01

setPINA 0x10
continue 2
expectPORTB 0x70
expect state WaitZero
expect floor 0x01

checkResult

# Add tests below

# Report on how many tests passed/tests ran
set $passed=$tests-$failed
eval "shell echo Passed %d/%d tests.\n",$passed,$tests
echo ======================================================\n
