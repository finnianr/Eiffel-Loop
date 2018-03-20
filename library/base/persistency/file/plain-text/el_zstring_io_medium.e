note
	description: "Text buffer medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-23 12:17:39 GMT (Friday 23rd February 2018)"
	revision: "3"

class
	EL_ZSTRING_IO_MEDIUM

inherit
	EL_STRING_IO_MEDIUM
		redefine
			text, put_string_general, put_string, put_string_8, put_string_32, put_raw_string_8, put_character_32
		end

create
	make, make_open_write, make_open_write_to_text, make_open_read_from_text

feature -- Access

	text: ZSTRING

	last_string: ZSTRING

feature -- Resizing

	grow (new_size: INTEGER)
			--
		do
			text.grow (new_size)
		end

feature -- Character output

	put_character_32 (c: CHARACTER_32)
		do
			text.append_unicode (c.natural_32_code)
		end

	put_raw_character_8 (c: CHARACTER)
			--
		do
			text.append_unicode (c.natural_32_code)
		end

feature -- String output

	put_raw_string_8 (utf_8: STRING)
		do
			text.append_utf_8 (utf_8)
		end

	put_string_general (str: READABLE_STRING_GENERAL)
		do
			text.append_string_general (str)
		end

	put_string_32 (str_32: STRING_32)
		do
			text.append_string_general (str_32)
		end

	put_string_8 (str_8: STRING)
		do
			text.append_string_general (str_8)
		end

	put_string (str: ZSTRING)
		do
			text.append_string (str)
		end

feature -- Numeric output

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

	set_last_string (a_string: like last_string)
		do
			last_string := a_string
		end

	new_string (a_count: INTEGER): like text
		do
			create Result.make (a_count)
		end
end
