note
	description: "Latin-1 code string that fits into 8 bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-17 13:26:15 GMT (Sunday 17th October 2021)"
	revision: "2"

class
	EL_CODE_STRING_REF

inherit
	DEBUG_OUTPUT
		rename
			debug_output as out
		redefine
			out
		end

feature -- Access

	to_reference: EL_CODE_STRING_REF
		do
			create Result
			Result.set_area (area)
		end

feature -- Output

	out: STRING
		-- Printable representation of code value
		do
			create Result.make (Byte_count)
			fill (Result)
		end

feature -- Basic operations

	fill (str: STRING)
		-- fill `str' from `area'
		require
			empty_string: str.is_empty
		local
			character_64, code_64: NATURAL_64
		do
			code_64 := area
			from character_64 := code_64 & Mask_byte_1 until not character_64.to_boolean loop
				str.prepend_character (character_64.to_character_8)
				code_64 := code_64 |>> 8
				character_64 := code_64 & Mask_byte_1
			end
		end

feature -- Status query

	same_string (str: STRING): BOOLEAN
		local
			character_64, code_64: NATURAL_64; i: INTEGER
		do
			if str.count <= byte_count then
				Result := True
				code_64 := area
				character_64 := code_64 & Mask_byte_1
				from i := str.count until not Result or else not character_64.to_boolean loop
					Result := str [i] = character_64.to_character_8
					code_64 := code_64 |>> 8
					character_64 := code_64 & Mask_byte_1
					i := i - 1
				end
				Result := Result and i = 0
			end
		end

feature -- Element change

	set (string: STRING)
		require
			valid_size: string.count <= Byte_count
		local
			code_64: NATURAL_64; i: INTEGER
			count: INTEGER
		do
			count := string.count.min (byte_count)
			from i := 1 until i > count loop
				code_64 := code_64 |<< 8 | string [i].natural_32_code.to_natural_64
				i := i + 1
			end
			area := code_64
		ensure
			reversible: out ~ string
		end

	set_area (a_area: NATURAL_64)
		do
			area := a_area
		end

feature -- Constants

	Byte_count: INTEGER = 8

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	area: NATURAL_64
		-- shifted characters

feature {NONE} -- Constants

	Mask_byte_1: NATURAL_64 = 0xFF

end