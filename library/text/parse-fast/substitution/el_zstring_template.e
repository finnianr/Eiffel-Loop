note
	description: "[$source EL_SUBSTITUTION_TEMPLATE] for [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 9:34:18 GMT (Saturday 5th November 2022)"
	revision: "9"

class
	EL_ZSTRING_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE

	EL_MODULE_STRING

create
	make, make_default

convert
	make ({STRING})

end