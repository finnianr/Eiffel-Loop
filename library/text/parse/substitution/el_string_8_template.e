note
	description: "${EL_SUBSTITUTION_TEMPLATE} for ${STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-25 14:18:57 GMT (Monday 25th March 2024)"
	revision: "4"

class
	EL_STRING_8_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE [STRING_8]

create
	make, make_default

convert
	make ({STRING, IMMUTABLE_STRING_8})

end