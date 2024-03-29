note
	description: "${TP_XML_IDENTIFIER} optimized for ${ZSTRING} source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	TP_ZSTRING_XML_IDENTIFIER

inherit
	TP_XML_IDENTIFIER
		undefine
			i_th_conforms
		end

	TP_OPTIMIZED_FOR_ZSTRING
	
feature {NONE} -- Implementation

	i_th_conforms (i: INTEGER_32; text: ZSTRING; is_first_character, uppercase_only, letter_first: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text.item_8 (i)
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
