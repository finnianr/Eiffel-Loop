note
	description: "Match XML language identifier name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 9:49:32 GMT (Monday 31st October 2022)"
	revision: "1"

class
	EL_MATCH_XML_IDENTIFIER_TP

inherit
	EL_MATCH_IDENTIFIER_TP

create
	make

feature {NONE} -- Implementation

	i_th_conforms (i: INTEGER_32; text: READABLE_STRING_GENERAL; is_first_character: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text [i]
				when 'a' .. 'z', 'A' .. 'Z', '_'  then
					Result := True

				when '0' .. '9', '.', '-' then
					Result := not is_first_character
			else
			end
		end

feature {NONE} -- Constants

	Language_name: STRING
		once
			Result := "XML"
		end

end