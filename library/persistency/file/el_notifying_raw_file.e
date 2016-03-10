note
	description: "Summary description for {EL_NOTIFYING_RAW_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-22 19:25:07 GMT (Friday 22nd March 2013)"
	revision: "2"

class
	EL_NOTIFYING_RAW_FILE

inherit
	EL_NOTIFYING_FILE
		rename
			index as position
		undefine
			file_reopen, file_open, file_dopen
		end

	RAW_FILE
		undefine
			make_with_name, open_read, open_write, close, move,
			read_character, read_line, read_to_managed_pointer,
			put_managed_pointer, put_character, put_string, put_new_line
		redefine
			read_integer, read_real, read_natural,
			put_integer, put_natural, put_real
		end

create
	make_with_name, make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature -- Input

	read_integer
			-- Read the binary representation of a new 32-bit integer
			-- from file. Make result available in `last_integer'.
		do
			Precursor
			listener.on_read ({PLATFORM}.integer_32_bytes)
		end

	read_real
			-- Read the binary representation of a new real
			-- from file. Make result available in `last_real'.
		do
			Precursor
			listener.on_read ({PLATFORM}.real_32_bytes)
		end

	read_natural
		do
			Precursor
			listener.on_read ({PLATFORM}.natural_32_bytes)
		end

feature -- Output

	put_integer (i: INTEGER)
			-- Write binary value of `i' at current position.
		do
			Precursor (i)
			listener.on_write ({PLATFORM}.integer_32_bytes)
		end

	put_natural (i: NATURAL_32)
		do
			Precursor (i)
			listener.on_write ({PLATFORM}.natural_32_bytes)
		end

	put_real (r: REAL)
			-- Write binary value of `r' at current position.
		do
			file_prb (file_pointer, r)
			listener.on_write ({PLATFORM}.real_32_bytes)
		end

end
