note
	description: "[$source EL_MATCH_XML_IDENTIFIER_TP] optimized for strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-12 12:16:15 GMT (Saturday 12th November 2022)"
	revision: "4"

class
	EL_MATCH_STRING_8_XML_IDENTIFIER_TP

inherit
	EL_MATCH_XML_IDENTIFIER_TP
		undefine
			i_th_conforms
		end

feature {NONE} -- Implementation

	i_th_conforms (
		i: INTEGER_32; text: READABLE_STRING_8; is_first_character, uppercase_only, letter_first: BOOLEAN
	): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text [i]
				when 'A' .. 'Z', '_'  then
					Result := True

				when 'a' .. 'z' then
					Result := not uppercase_only

				when '0' .. '9', '.', '-' then
					Result := not is_first_character
			else
			end
		end

end