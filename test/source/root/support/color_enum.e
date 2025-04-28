note
	description: "Primary color enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 17:30:54 GMT (Monday 28th April 2025)"
	revision: "5"

class
	COLOR_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Colors

	blue: NATURAL_8

	green: NATURAL_8

	red: NATURAL_8

end