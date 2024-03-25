note
	description: "${EL_SUBSTITUTION_TEMPLATE} for ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-25 10:17:00 GMT (Monday 25th March 2024)"
	revision: "4"

class
	EL_ZSTRING_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE

	EL_MODULE_STRING

create
	make, make_default

convert
	make ({STRING, STRING_32})

end