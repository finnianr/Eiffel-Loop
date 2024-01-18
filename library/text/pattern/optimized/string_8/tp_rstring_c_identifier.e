note
	description: "${TP_C_IDENTIFIER} optimized for strings conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:44:41 GMT (Saturday 3rd December 2022)"
	revision: "4"

class
	TP_RSTRING_C_IDENTIFIER

inherit
	TP_C_IDENTIFIER
		redefine
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
				when 'A' .. 'Z' then
					Result := True
				when 'a' .. 'z' then
					Result := not uppercase_only
				when '0' .. '9' then
					Result := not is_first_character
				when '_' then
					Result := letter_first implies not is_first_character
			else
			end
		end

end
