#!/usr/bin/env ruby

# ROMCOM inserts comments into a Newton ROM disassembly
# by Steven Frank <stevenf@panic.com>
#
# Takes two files as input: newtonos.s and comments.txt.
#
#   newtonos.s is a Newton ROM disassembly as generated by Matthias' 
#   disassembler.
#
#   comments.txt is a specially formatted text file containing
#   comments to inject into the disassembly.
#
# The disassembly is expected to contain "address tags" that this script
# uses as anchor points to find where to insert the comments.  An example
# line of disassembly:
#
#        b       ROMBoot          @ 0x00000000 0xEA0061A0 - ..a.
#
# b is the instruction, ROMBoot is a symbol, @ 0x00000000 is the address tag
# this script will look for, 0xEA0061A0 is the hex value of the instruction
# and ..a. is that hex rendered as ASCII text.
#
# Here's a sample comments.txt:
#
# 00000000 ' @@ This is the ROM disassembly, generated by a bunch of fans
# 00000000 ' @@ Make sure that comments you commit are correct
# 00000000 ' @@
# 00000000 ' @@ The ARM CPU jumps here when reset is pressed or when switched on
# 00000000 - @@ jump to ROMBoot
# 00000004 ' @@ CPU jumps here if an undefined instruction was found
# 00000004 - @@ What a funny name for a label
#
# The first column are 32-bit hex addresses of locations in the ROM.  We
# expect comments.txt to be sorted on this field.
#
# The second field is either a ' or -
#
# - indicates an inline comment to be placed at the very end of the line
# ' indicates a "block" type comment to be inserted line-by-line at the address
#
# The rest of the line starting with the @@ is treated literally as the 
# comment to be inserted.

ABOVE = '\''
INLINE = '-'
DEBUG = false

disassembly_path = './newtonos.s'
comments_path = './comments.txt'

disassembly = File.open(disassembly_path, 'r')
comments = File.open(comments_path, 'r')

disassembly_pc = nil
saved_disassembly_line = nil

# Iterate line-by-line through comments file

while comment_line = comments.gets() do
	
	regex = /^([0123456789ABCDEF]+) (['\-]) (.*)$/
	matches = comment_line.match(regex)
	
	if matches.nil?
		captures = [];
	else
		captures = matches.captures
	end
	
	comment_pc = captures[0]
	comment_type = captures[1] # ABOVE or INLINE
	comment_text = captures[2]

	if DEBUG
		puts ">> read new comment for #{comment_pc}"
		puts ">> #{comment_line}"
	end
	
	if comment_pc == disassembly_pc
		if comment_type == ABOVE
			# Inserting a multi-line comment at an address we've already found
			
			puts "\t#{comment_text}"
			next

		elsif comment_type == INLINE
			if !saved_disassembly_line.nil?
				# Showing an inline comment that we've been holding onto
				
				saved_disassembly_line = saved_disassembly_line.chomp
				puts "#{saved_disassembly_line}\t#{comment_text}"
				saved_disassembly_line = nil
				next
			end
		end	
	else
		if !saved_disassembly_line.nil?
			puts saved_disassembly_line
			saved_disassembly_line = nil
		end
	end
	
	# Iterate through disassembly looking for the next address tag
	
	while disassembly_line = disassembly.gets() do
		# Look for an address tag on this line of disassembly

		if DEBUG
			puts ">> read from disassembly: #{disassembly_line}"
		end	
		
		regex = /\@ 0x([0123456789ABCDEF]+) /
		match = disassembly_line.match(regex)

		if !match.nil?
			# Found an address tag

			captures = match.captures
			disassembly_pc = captures[0]

			if DEBUG
				puts ">> found an address tag (#{disassembly_pc})"
			end			

			if comment_pc == disassembly_pc
				# Insert the comment if the addresses match up
			
				if comment_type == ABOVE
					puts "\t#{comment_text}"
					
					# Hang on to the disassembly line that we haven't
					# printed yet until the "above" comment is done.
					
					saved_disassembly_line = disassembly_line
					
					if DEBUG 
						puts ">> saving for later: #{saved_disassembly_line}"
					end
					break
					
				elsif comment_type == INLINE
					puts "#{disassembly_line}\t#{comment_text}"
					saved_disassembly_line = nil
					break
				end
			else
				puts disassembly_line
				saved_disassembly_line = nil
			end
		else
			if DEBUG
				puts ">> no address tag"
			end
			
			if saved_disassembly_line
				puts saved_disassembly_line
				saved_disassembly_line = nil
			end

			puts disassembly_line
			saved_disassembly_line = nil
		end		
	end
end

# Hit the end of comments.txt, so just run through the rest of the disassembly

while disassembly_line = disassembly.gets() do
	puts disassembly_line
end

comments.close()
disassembly.close()


