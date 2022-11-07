note
	description: "[$source EL_MATCH_C_IDENTIFIER_TP] optimized for strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-07 10:21:04 GMT (Monday 7th November 2022)"
	revision: "2"

class
	EL_MATCH_STRING_8_C_IDENTIFIER_TP

inherit
	EL_MATCH_C_IDENTIFIER_TP
		redefine
			i_th_conforms
		end

create
	make, make_upper

feature {NONE} -- Implementation

	i_th_conforms (i: INTEGER_32; text: READABLE_STRING_8; is_first_character, uppercase_only: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text [i]
				when 'A' .. 'Z', '_'  then
					Result := True
				when 'a' .. 'z' then
					Result := not uppercase_only
				when '0' .. '9' then
					Result := not is_first_character
			else
			end
		end

end