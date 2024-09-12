note
	description: "Primary color enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-12 15:05:16 GMT (Thursday 12th September 2024)"
	revision: "3"

class
	COLOR_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			description_table as No_descriptions,
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Colors

	blue: NATURAL_8

	green: NATURAL_8

	red: NATURAL_8

end