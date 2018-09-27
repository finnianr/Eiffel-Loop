note
	description: "Url query string 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "7"

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
