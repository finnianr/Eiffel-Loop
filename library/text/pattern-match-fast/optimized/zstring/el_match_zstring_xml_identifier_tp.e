note
	description: "[$source EL_MATCH_XML_IDENTIFIER_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 9:49:46 GMT (Monday 31st October 2022)"
	revision: "1"

class
	EL_MATCH_ZSTRING_XML_IDENTIFIER_TP

inherit
	EL_MATCH_XML_IDENTIFIER_TP
		undefine
			i_th_conforms
		end

	STRING_HANDLER

create
	make

feature {NONE} -- Implementation

	i_th_conforms (i: INTEGER_32; text: ZSTRING; is_first_character: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text.item_8 (i)
				when 'a' .. 'z', 'A' .. 'Z', '_'  then
					Result := True

				when '0' .. '9', '.', '-' then
					Result := not is_first_character
			else
			end
		end
end