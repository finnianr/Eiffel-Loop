note
	description: "Windows, Latin, or UTF encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 10:33:26 GMT (Tuesday 18th February 2020)"
	revision: "4"

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
	make_default, make_utf_8, make_latin_1, make_from_name, make_from_other

convert
	make_from_other ({EL_ENCODING_BASE})

feature {NONE} -- Initialization

	make_from_name (a_name: STRING)
		do
			make_default
			set_from_name (a_name)
		end

	make_from_other (other: EL_ENCODING_BASE)
		do
			make_bitmap (other.encoding_bitmap)
		end

end
