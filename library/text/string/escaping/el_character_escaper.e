note
	description: "Summary description for {EL_CHARACTER_ESCAPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_CHARACTER_ESCAPER

inherit
	EL_SHARED_ONCE_STRINGS

feature -- Conversion

	escaped (str: READABLE_STRING_GENERAL): STRING_32
		local
			l_result: STRING_32; c: CHARACTER_32
			l_character_intervals: like character_intervals; l_characters: like characters
			range: like character_intervals.item
			i, j: INTEGER; found: BOOLEAN
		do
			l_result := empty_once_string_32; l_result.grow (str.count)
			l_character_intervals := character_intervals; l_characters := characters
			from i := 1 until i > str.count loop
				c := str [i]
				if l_characters.has (c) then
					append_escape_sequence (l_result, c)
				else
					from j := 0; found := False until found or else j = l_character_intervals.count loop
						range := l_character_intervals [j]
						found := range.from_code <= c and c <= range.to_code
						j := j + 1
					end
					if found then
						append_escape_sequence (l_result, c)
					else
						l_result.append_character (c)
					end
				end
				i := i + 1
			end
			Result := l_result.twin
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: STRING_32; c: CHARACTER_32)
		deferred
		ensure
			string_is_longer: str.count > old str.count
		end

	character_intervals: SPECIAL [TUPLE [from_code, to_code: CHARACTER_32]]
		deferred
		end

	characters: STRING_32
		deferred
		end

end
