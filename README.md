# ROMCOM

### by Steven Frank <stevenf@panic.com>

ROMCOM (short for "ROM Commenter") is intended to insert comments into a disassembly of a Newton ROM.  It is part of the larger "Einstein" project for simulating the Newton OS platform.

Given that we have a Newton ROM image, and a tool that can produce a disassembly of that image, we wanted a way that developers could inject comments into that disassembly without making public the ROM image or any part of the actual disassembly (due to legal concerns).

So, ROMCOM takes a file containing a list of address offsets and comments, and essentially splices the comments into the right places in the disassembly.

There is no ROM image in this repository, and only a short snippet of a sample disassembly and a short example of the comments file are provided for testing purposes.

More information on how to use the script is located at the top of the script (romcom.rb)

## Sample disassembly:

```
	.include	"macros.s"

	.text
	.org	0

	.global	_start
_start:

Reset:
	@ label = 'Reset'
	b       ROMBoot                   	@ 0x00000000 0xEA0061A0 - ..a. 

_UndefinedInstruction:
	@ label = '_UndefinedInstruction'
	b       VEC_FP_UndefHandlers_Start_JT  	@ 0x00000004 0xEA680C7A - .h.z 

_SoftwareInterrupt:
	@ label = '_SoftwareInterrupt'
	b       VEC_SWIBoot               	@ 0x00000008 0xEA6C2101 - .l!. 

_AbortPrefetch:
	@ label = '_AbortPrefetch'
	b       VEC_PrefetchAbortHandler  	@ 0x0000000C 0xEA67FFFF - .g.. 

_AbortData:
	@ label = '_AbortData'
	b       DataAbortHandler          	@ 0x00000010 0xEA0E4C3F - ..L? 
```

## Sample comments file:

```
00000000 ' @@ This is the ROM disassembly, generated by a bunch of fans
00000000 ' @@ Make sure that comments you commit are correct
00000000 ' @@
00000000 ' @@ The ARM CPU jumps here when reset is pressed or when switched on
00000000 - @@ jump to ROMBoot
00000004 ' @@ CPU jumps here if an undefined instruction was found
00000004 - @@ What a funny name for a label
```

## Desired output:

```
	.include	"macros.s"

	.text
	.org	0

	.global	_start
_start:

Reset:
	@ label = 'Reset'
	@@ This is the ROM disassembly, generated by a bunch of fans
	@@ Make sure that comments you commit are correct
	@@
	@@ The ARM CPU jumps here when reset is pressed or when switched on
	b       ROMBoot                   	@ 0x00000000 0xEA0061A0 - ..a. 	@@ jump to ROMBoot

_UndefinedInstruction:
	@ label = '_UndefinedInstruction'
	@@ CPU jumps here if an undefined instruction was found
	b       VEC_FP_UndefHandlers_Start_JT  	@ 0x00000004 0xEA680C7A - .h.z 	@@ What a funny name for a label

_SoftwareInterrupt:
	@ label = '_SoftwareInterrupt'
	b       VEC_SWIBoot               	@ 0x00000008 0xEA6C2101 - .l!. 

_AbortPrefetch:
	@ label = '_AbortPrefetch'
	b       VEC_PrefetchAbortHandler  	@ 0x0000000C 0xEA67FFFF - .g.. 

_AbortData:
	@ label = '_AbortData'
	b       DataAbortHandler          	@ 0x00000010 0xEA0E4C3F - ..L? 
```
