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
	date: "2024-08-28 6:39:13 GMT (Wednesday 28th August 2024)"
	revision: "2"

class
	EL_BOOLEAN_ON_OFF_ENUM

inherit
	EL_BOOLEAN_ENUMERATION
		rename
			foreign_naming as eiffel_naming,
			is_true as on,
			is_false as off
		end

create
	make
end