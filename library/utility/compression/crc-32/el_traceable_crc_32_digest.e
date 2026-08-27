note
	description: "[
		${EL_CRC_32_DIGEST} with indexed trace output on IO for debugging
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2026-07-09 20:15:00 GMT (Thursday 9th July 2026)"
	revision: "1"

class
	EL_TRACEABLE_CRC_32_DIGEST

inherit
	EL_CRC_32_DIGEST
		redefine
			add_boolean, add_characters, add_integer_32, default_create, reset
		end

create
	default_create

convert
	to_integer_32: {INTEGER_32}

feature {NONE} -- Initialization

	default_create
		local
			integer: EL_INTEGER_MATH; n: INTEGER
		do
			Precursor
			create zeros.make_filled ('0', integer.digit_count (n.Max_value))
		end

feature -- Element change

	add_boolean (flag: BOOLEAN)
		do
			Precursor (flag)
			put_digest_trace (False)
			IO.put_boolean (flag)
			IO.put_new_line
		end

	add_characters (area: SPECIAL [CHARACTER]; lower, upper: INTEGER)
		local
			c_i, code: CHARACTER; i: INTEGER
		do
			Precursor (area, lower, upper)
			if upper >= lower then
				put_digest_trace (True)
				from i := lower until i > upper loop
					c_i := area [i]
					inspect c_i
						when '%N' then
							code := 'N'
						when '%R' then
							code := 'R'
						when '%T' then
							code := 'T'
					else
						code := '%U'
						io.put_character (c_i)
					end
					if code > '%U' then
						io.put_character ('%%'); io.put_character (code)
					end
					i := i + 1
				end
				IO.put_character ('%"')
				IO.put_new_line
			end
		end

	add_integer_32 (integer: INTEGER_32)
		do
			Precursor (integer)
			put_digest_trace (False)
			IO.put_integer (integer)
			IO.put_new_line
		end

feature {NONE} -- Implementation

	put_digest_trace (is_string: BOOLEAN)
		local
			integer: EL_INTEGER_MATH
		do
			index := index + 1
			zeros.set_count (7 - integer.digit_count (index))
			IO.put_character ('#')
			IO.put_string (zeros)
			IO.put_integer (index)
			IO.put_string (once " (")
			IO.put_natural_64 (item)
			IO.put_string (once "): ")
			if is_string then
				IO.put_character ('"')
			end
		end

	reset
		do
			set_item (Crc_initial)
			index := 0
		end

feature {NONE} -- Internal attributes

	index: INTEGER

	zeros: STRING

end
