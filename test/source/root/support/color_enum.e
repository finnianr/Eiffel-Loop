note
	description: "Primary color enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 11:30:41 GMT (Monday 28th April 2025)"
	revision: "4"

class
	COLOR_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_string_8,
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Colors

	blue: NATURAL_8

	green: NATURAL_8

	red: NATURAL_8

end