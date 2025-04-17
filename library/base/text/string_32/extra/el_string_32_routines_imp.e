note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 16:04:25 GMT (Wednesday 16th April 2025)"
	revision: "76"

class EL_STRING_32_ROUTINES_IMP inherit ANY

	EL_STRING_X_ROUTINES [STRING_32, READABLE_STRING_32, CHARACTER_32]
		undefine
			bit_count
		end

	EL_STRING_GENERAL_ROUTINES_I
		export
			{ANY} as_zstring, ZSTRING
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_STRING_32_CONSTANTS

	EL_SHARED_IMMUTABLE_32_MANAGER

feature -- Comparison

	occurs_at (big, small: STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

	same_string (a, b: READABLE_STRING_32): BOOLEAN
		do
			Result := EL_string_32.same_strings (a, b)
		end

feature -- Basic operations

	append_to (str: STRING_32; extra: READABLE_STRING_GENERAL)
		do
			if conforms_to_zstring (extra) then
				as_zstring (extra).append_to_string_32 (str)
			else
				str.append_string_general (extra)
			end
		end

	set_upper (str: STRING_32; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

feature -- Conversion

	to_code_array (s: STRING_32): ARRAY [NATURAL_32]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i)
				i := i + 1
			end
		end

feature -- Factory

	new_list (comma_separated: STRING_32): EL_STRING_32_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

feature {NONE} -- Implementation

	append_utf_8_to (utf_8: READABLE_STRING_8; output: STRING_32)
		local
			u8: EL_UTF_8_CONVERTER
		do
			u8.string_8_into_string_general (utf_8, output)
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_32; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string_32 (target, pattern, 0)
		end

	split_on_character (str: READABLE_STRING_32; separator: CHARACTER_32): EL_SPLIT_ON_CHARACTER_32 [READABLE_STRING_32]
		do
			if str.is_immutable then
				Result := Split_immutable_string_32
			else
				Result := Split_string_32
			end
			Result.set_target (str); Result.set_separator (separator)
		end

feature {NONE} -- Constants

	Split_string_32: EL_SPLIT_ON_CHARACTER_32 [STRING_32]
		once
			create Result.make (Empty_string_32, '_')
		end

	Split_immutable_string_32: EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER
		once
			create Result.make (Empty_string_32, '_')
		end

end