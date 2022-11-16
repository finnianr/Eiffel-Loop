note
	description: "[$source EL_MATCH_XML_IDENTIFIER_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:55:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_XML_IDENTIFIER_TP

inherit
	EL_MATCH_XML_IDENTIFIER_TP
		undefine
			i_th_conforms
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING
	
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