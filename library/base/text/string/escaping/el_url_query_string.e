note
	description: "Summary description for {EL_URL_QUERY_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-26 12:02:01 GMT (Friday 26th August 2016)"
	revision: "1"

class
	EL_URL_QUERY_STRING

inherit
	EL_URL_STRING
		redefine
			append_encoded, append_decoded_utf_8, is_unescaped
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	append_decoded_utf_8 (utf_8: STRING; c: CHARACTER)
		do
			if c = '+' then
				utf_8.append_character (' ')
			else
				utf_8.append_character (c)
			end
		end

	append_encoded (c: CHARACTER)
		do
			if c = ' ' then
				append_character ('+')
			else
				Precursor (c)
			end
		end

	is_unescaped (c: CHARACTER): BOOLEAN
		do
			inspect c
				when '0' .. '9', 'A' .. 'Z', 'a' .. 'z' then
					Result := True
				when '*', '-', '.', '_'  then
					Result := True

			else end
		end
end
