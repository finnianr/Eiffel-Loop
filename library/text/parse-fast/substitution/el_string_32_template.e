note
	description: "[$source EL_SUBSTITUTION_TEMPLATE] for [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

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