note
	description: "Summary description for {EL_CHARACTER_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-18 14:12:56 GMT (Monday 18th July 2016)"
	revision: "1"

deferred class
	EL_CHARACTER_ESCAPER [S -> STRING_GENERAL create make end]

inherit
	EL_SHARED_ONCE_STRINGS

	EL_SHARED_ZCODEC

feature -- Conversion

	escaped (str: READABLE_STRING_GENERAL): S
		do
			create Result.make (str.count)
			if attached {EL_ZSTRING} str as str_z then
				zstring_escaped_in_to (str_z, Result)
			else
				escaped_in_to (str, Result)
			end
		end

	escaped_in_to (str: READABLE_STRING_GENERAL; escaped_out: S)
		local
			code: NATURAL; l_characters: like characters; i, count: INTEGER
		do
			l_characters := characters; count := str.count
			from i := 1 until i > count loop
				code := str.code (i)
				if is_escaped (l_characters, code) then
					append_escape_sequence (escaped_out, code)
				else
					escaped_out.append_code (code)
				end
				i := i + 1
			end
		end

	zstring_escaped_in_to (str: EL_ZSTRING; escaped_out: S)
		local
			unicode, z_code: NATURAL; l_characters: like characters; i, count: INTEGER
			unicode_table: like codec.unicode_table
		do
			unicode_table := codec.unicode_table
			l_characters := characters; count := str.count
			from i := 1 until i > count loop
				z_code := str.z_code (i)
				if z_code > 0xFF then
					unicode := z_code_to_unicode (z_code)
				else
					unicode := unicode_table.item (z_code.to_integer_32).natural_32_code
				end
				if is_escaped (l_characters, unicode) then
					append_escape_sequence (escaped_out, unicode)
				else
					escaped_out.append_code (z_code)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	append_escape_sequence (str: S; code: NATURAL)
		deferred
		ensure
			string_is_longer: str.count > old str.count
		end

	characters: STRING_32
		deferred
		end

	is_escaped (a_characters: like characters; code: NATURAL): BOOLEAN
		do
			Result := a_characters.has_code (code)
		end

end