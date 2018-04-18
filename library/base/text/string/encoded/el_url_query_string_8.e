note
	description: "Summary description for {EL_URL_QUERY_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 16:40:44 GMT (Monday 9th April 2018)"
	revision: "4"

class
	EL_URL_QUERY_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			append_encoded, adjusted_character, is_unescaped_extra
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	adjusted_character (c: CHARACTER): CHARACTER
		do
			if c = '+' then
				Result := ' '
			else
				Result := c
			end
		end

	append_encoded (utf_8: like Utf_8_sequence; uc: CHARACTER_32)
		do
			if uc = ' ' then
				append_character ('+')
			else
				Precursor (utf_8, uc)
			end
		end

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		do
			inspect c
				when '*', '-', '.', '_'  then
					Result := True

			else end
		end
end
