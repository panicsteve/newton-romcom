# ROMCOM

## ROMCOM (short for "ROM Commenter") is intended to insert comments into a disassembly of a Newton ROM.  It is part of the larger "Einstein" project for simulating the Newton OS platform.

### by Steven Frank <stevenf@panic.com>

Given that we have a Newton ROM image, and a tool that can produce a disassembly of that image, we wanted a way that developers could inject comments into that disassembly without making public any part of the actual disassembly (out of legal concerns).

So, ROMCOM takes a file containing a list of address offsets and comments, and essentially splices into the right places in the disassembly.

There is no ROM image here, and only a short snippet of a sample disassembly and a short example of the comments file are provided for testing purposes.

More information on how to use the script is located at the top of the script (romcom.rb)

