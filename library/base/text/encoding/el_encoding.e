note
	description: "Windows, Latin, or UTF encoding"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 11:14:07 GMT (Saturday 5th November 2022)"
	revision: "8"

class
	EL_ENCODING

inherit
	EL_ENCODING_BASE
		rename
			valid_encoding as is_valid
		end

	EL_MAKEABLE_FROM_STRING [STRING_8]
		rename
			make as make_from_name,
			to_string as name
		end

create
	make_default, make, make_from_name, make_from_other

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
			make (other.encoding)
		end

end