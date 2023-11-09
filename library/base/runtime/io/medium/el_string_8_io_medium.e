note
	description: "STRING_8 buffer medium with UTF-8 encoding by default"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 17:23:33 GMT (Thursday 9th November 2023)"
	revision: "13"

class
	EL_STRING_8_IO_MEDIUM

inherit
	EL_STRING_IO_MEDIUM
		redefine
			text, put_encoded_string_8
		end

create
	make, make_open_write, make_open_write_to_text, make_open_read_from_text

feature -- Access

	text: STRING

feature -- Resizing

	grow (new_size: INTEGER)
			--
		do
			text.grow (new_size)
		end

feature -- Output

	put_encoded_character_8 (c: CHARACTER)
			--
		do
			text.append_character (c)
		end

	put_encoded_string_8 (a_encoded: STRING_8)
		-- put encoded string
		do
			text.append (a_encoded)
		end

	put_real, putreal (r: REAL)
			--
		do
			text.append_real (r)
		end

	put_integer, putint, put_integer_32 (i: INTEGER)
			--
		do
			text.append_integer (i)
		end

	put_integer_8 (i: INTEGER_8)
			--
		do
			text.append_integer_8 (i)
		end

	put_integer_16 (i: INTEGER_16)
			--
		do
			text.append_integer_16 (i)
		end

	put_integer_64 (i: INTEGER_64)
			--
		do
			text.append_integer_64 (i)
		end

	put_boolean, putbool (b: BOOLEAN)
		do
			text.append_boolean (b)
		end

	put_double, putdouble (d: DOUBLE)
		do
			text.append_double (d)
		end

	put_natural_8 (n: NATURAL_8)
			--
		do
			text.append_natural_8 (n)
		end

	put_natural_16 (n: NATURAL_16)
			--
		do
			text.append_natural_16 (n)
		end

	put_natural, put_natural_32 (n: NATURAL_32)
			--
		do
			text.append_natural_32 (n)
		end

	put_natural_64 (n: NATURAL_64)
			--
		do
			text.append_natural_64 (n)
		end

feature {NONE} -- Implementation

	set_last_string (start_index, end_index: INTEGER)
		do
			last_string.wipe_out
			last_string.append_substring (text, start_index, end_index)
		end

	new_string (a_count: INTEGER): like text
		do
			create Result.make (a_count)
		end

	wipe_out_text
		do
			text.wipe_out
		end

end