note
	description: "[
		Alpha-numeric code that fits into `byte_count' bytes as an expanded type conforming to [$source NUMERIC]
	]"
	descendants: "[
			EL_NUMERIC_CODE*
				[$source EL_CODE_16]
				[$source EL_CODE_64]
				[$source EL_CODE_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-16 14:21:56 GMT (Saturday 16th October 2021)"
	revision: "2"

deferred class
	EL_ALPHA_NUMERIC_CODE

inherit
	DEBUG_OUTPUT
		rename
			debug_output as out
		undefine
			is_equal
		redefine
			out
		end

feature -- Conversion

	to_natural_64: NATURAL_64
		deferred
		end

	to_reference: EL_ALPHA_NUMERIC_CODE
		deferred
		end

feature -- Measurement

	byte_count: INTEGER
		deferred
		end

feature -- Output

	out: STRING
		-- Printable representation of code value
		do
			create Result.make (byte_count)
			fill (Result)
		end

feature -- Basic operations

	fill (str: STRING)
		require
			empty_string: str.is_empty
		local
			character_64, code_64: NATURAL_64
		do
			code_64 := to_natural_64
			from character_64 := code_64 & Mask_byte_1 until not character_64.to_boolean loop
				str.prepend_character (character_64.to_character_8)
				code_64 := code_64 |>> 8
				character_64 := code_64 & Mask_byte_1
			end
		end

feature -- Status query

	same_as (str: STRING): BOOLEAN
		local
			character_64, code_64: NATURAL_64; i: INTEGER
		do
			if str.count <= byte_count then
				Result := True
				code_64 := to_natural_64
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
			valid_size: string.count <= byte_count
		local
			code_64: NATURAL_64; i: INTEGER
			count: INTEGER
		do
			count := string.count.min (byte_count)
			from i := 1 until i > count loop
				code_64 := code_64 |<< 8 | string [i].natural_32_code.to_natural_64
				i := i + 1
			end
			set_from_code (code_64)
		ensure
			reversible: out ~ string
		end

feature {NONE} -- Implementation

	set_from_code (code_64: NATURAL_64)
		deferred
		end

feature {NONE} -- Constants

	Mask_byte_1: NATURAL_64 = 0xFF
end