note
	description: "[$source EL_MATCH_C_IDENTIFIER_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 9:13:06 GMT (Friday 11th November 2022)"
	revision: "4"

class
	EL_MATCH_ZSTRING_C_IDENTIFIER_TP

inherit
	EL_MATCH_C_IDENTIFIER_TP
		redefine
			i_th_conforms
		end

create
	default_create, make_upper

feature {NONE} -- Implementation

	i_th_conforms (i: INTEGER_32; text: ZSTRING; is_first_character, uppercase_only: BOOLEAN): BOOLEAN
		-- `True' if i'th character conforms to language rule
		do
			inspect text.item_8 (i)
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