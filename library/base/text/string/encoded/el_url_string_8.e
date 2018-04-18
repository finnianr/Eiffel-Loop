note
	description: "URL encoded string with unescaped path separator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-01 14:30:21 GMT (Sunday 1st April 2018)"
	revision: "6"

class
	EL_URL_STRING_8

inherit
	EL_URI_STRING_8
		redefine
			is_unescaped_extra
		end

create
	make_encoded, make_empty, make

convert
	make_encoded ({STRING})

feature {NONE} -- Implementation

	is_unescaped_extra (c: CHARACTER_32): BOOLEAN
		do
			if c = '/' then
				Result := True
			else
				Result := Precursor (c)
			end
		end

end
