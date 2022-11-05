note
	description: "[$source EL_SUBSTITUTION_TEMPLATE] for [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-05 9:31:58 GMT (Saturday 5th November 2022)"
	revision: "10"

class
	EL_STRING_8_TEMPLATE

inherit
	EL_SUBSTITUTION_TEMPLATE
		rename
			string as string_8
		end

	EL_MODULE_STRING_8

create
	make, make_default

convert
	make ({STRING})

end