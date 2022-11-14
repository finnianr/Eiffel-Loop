note
	description: "[$source EL_SUBSTITUTION_TEMPLATE] for [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:24:50 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_STRING_32_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE
		rename
			string as string_32
		end

	EL_MODULE_STRING_32

create
	make, make_default

convert
	make ({STRING})

end