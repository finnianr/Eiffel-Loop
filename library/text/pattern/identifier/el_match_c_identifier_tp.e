note
	description: "Match C language identifier name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-09 16:27:03 GMT (Wednesday 9th November 2022)"
	revision: "3"

class
	EL_MATCH_C_IDENTIFIER_TP

inherit
	EL_MATCH_IDENTIFIER_TP

create
	default_create, make_upper

feature {NONE} -- Implementation

	i_th_conforms (i: INTEGER_32; text: READABLE_STRING_GENERAL; is_first_character, uppercase_only: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text [i]
				when  'A' .. 'Z', '_'  then
					Result := True

				when 'a' .. 'z'  then
					Result := not uppercase_only

				when '0' .. '9' then
					Result := not is_first_character
			else
			end
		end

feature {NONE} -- Constants

	Language_name: STRING
		once
			Result := "C"
		end

end