
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

