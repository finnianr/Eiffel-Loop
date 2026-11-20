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
			add_boolean, add_character_buffer, add_characters, add_integer_32, add_string,
			default_create, reset
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
			create escape_characters.make_filled ('%U', {ASCII}.CR) -- 13

			escape_characters [{ASCII}.BS] := 'B' --	BS (backspace, 8)
			escape_characters [{ASCII}.HT] := 'T' --	HT (tab, 9)
			escape_characters [{ASCII}.NL] := 'N' --	NL / LF (newline, 10)
			escape_characters [12]			 := 'F' --	FF (form feed, 12)
			escape_characters [{ASCII}.CR] := 'R' --	CR (carriage return, 13)
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
			put_indexable (area, lower, upper)
		end

	add_character_buffer (buffer: EL_CHARACTER_8_BUFFER; lower, upper: INTEGER)
		do
			Precursor (buffer, lower, upper)
			put_indexable (buffer, lower, upper)
		end

	add_integer_32 (integer: INTEGER_32)
		do
			Precursor (integer)
			put_digest_trace (False)
			IO.put_integer (integer)
			IO.put_new_line
		end

	add_string (str: STRING_8)
		do
			if str.is_empty then
				put_digest_trace (True)
				IO.put_character ('"')
				IO.put_new_line
			else
				Precursor (str)
			end
		end


feature {NONE} -- Implementation

	escaped_character (c: CHARACTER): CHARACTER
		do
			inspect c.code when {ASCII}.BS .. {ASCII}.CR then
				Result := escape_characters [c.code]
			else
				Result := '%U'
			end
		ensure
		end

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

	put_indexable (area: READABLE_INDEXABLE [CHARACTER]; lower, upper: INTEGER)
		local
			c_i, escaped_c_i: CHARACTER; i: INTEGER
		do
			if upper >= lower then
				put_digest_trace (True)
				from i := lower until i > upper loop
					c_i := area [i]
					escaped_c_i := escaped_character (c_i)
					inspect escaped_c_i when '%U' then
						IO.put_character (c_i)
					else
						IO.put_character ('%%'); io.put_character (escaped_c_i)
					end
					i := i + 1
				end
				IO.put_character ('%"')
				IO.put_new_line
			end
		end

	reset
		do
			set_item (CRC_initial)
			index := 0
		end

feature {NONE} -- Internal attributes

	index: INTEGER

	zeros: STRING

	escape_characters: STRING

end
