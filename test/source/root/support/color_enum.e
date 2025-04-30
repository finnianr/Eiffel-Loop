note
	description: "Primary color enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:05:36 GMT (Wednesday 30th April 2025)"
	revision: "6"

class
	COLOR_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as default_translater
		end

create
	make

feature -- Colors

	blue: NATURAL_8

	green: NATURAL_8

	red: NATURAL_8

end