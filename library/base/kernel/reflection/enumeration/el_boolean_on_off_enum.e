note
	description: "[
		{EL_BOOLEAN_ENUMERATION} with boolean string mapping
		
			True -> "on"
			False -> "off"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:10:06 GMT (Wednesday 30th April 2025)"
	revision: "3"

class
	EL_BOOLEAN_ON_OFF_ENUM

inherit
	EL_BOOLEAN_ENUMERATION
		rename
			is_true as on,
			is_false as off
		end

create
	make
end