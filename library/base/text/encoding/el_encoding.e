note
	description: "Windows, Latin, or UTF encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 13:45:47 GMT (Wednesday 29th January 2020)"
	revision: "2"

class
	EL_ENCODING

inherit
	EL_ENCODING_BASE

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_name,
			to_string as name
		end

create
	make_default, make_utf_8, make_latin_1, make_from_name

feature {NONE} -- Initialization

	make_from_name (a_name: STRING)
		do
			make_default
			set_from_name (a_name)
		end

end
