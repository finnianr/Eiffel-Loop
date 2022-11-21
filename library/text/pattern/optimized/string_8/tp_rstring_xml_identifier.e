note
	description: "[$source TP_XML_IDENTIFIER] optimized for strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:58 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_RSTRING_XML_IDENTIFIER

inherit
	TP_XML_IDENTIFIER
		undefine
			i_th_conforms
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

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

