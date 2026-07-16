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
			add_bytes, add_characters, default_create
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

	add_bytes (byte_array: POINTER; count: INTEGER)
		do
			Precursor (byte_array, count)
			if count > 0 then
				put_digest_trace
			end
		end

	add_characters (area: SPECIAL [CHARACTER]; lower, upper: INTEGER)
		local
			c_i, code: CHARACTER; i: INTEGER
		do
			Precursor (area, lower, upper)
			put_digest_trace
			if upper >= lower then
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
				io.put_character ('%"')
				io.put_new_line
			end
		end

feature {NONE} -- Implementation

	put_digest_trace
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
			IO.put_string (once "): %"")
		end

feature {NONE} -- Internal attributes

	index: INTEGER

	zeros: STRING

end
