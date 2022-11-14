note
	description: "Match C language identifier name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:17:33 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_C_IDENTIFIER_TP

inherit
	EL_MATCH_IDENTIFIER_TP

feature {NONE} -- Implementation

	i_th_conforms (
		i: INTEGER_32; text: READABLE_STRING_GENERAL; is_first_character, uppercase_only, letter_first: BOOLEAN
	): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text [i]
				when  'A' .. 'Z' then
					Result := True

				when 'a' .. 'z'  then
					Result := not uppercase_only

				when '0' .. '9' then
					Result := not is_first_character

				when '_' then
					Result := letter_first implies not is_first_character

			else
			end
		end

feature {NONE} -- Constants

	Language_name: STRING
		once
			Result := "C"
		end

end