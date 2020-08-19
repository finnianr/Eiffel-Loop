note
	description: "Button state enumeration accessible via [$source EL_SHARED_BUTTON_STATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-19 11:50:11 GMT (Wednesday 19th August 2020)"
	revision: "1"

class
	EL_BUTTON_STATE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_snake_case_lower,
			import_name as from_snake_case_lower
		end

create
	make

feature -- Access

	depressed: NATURAL_8

	highlighted: NATURAL_8

	normal: NATURAL_8
end
