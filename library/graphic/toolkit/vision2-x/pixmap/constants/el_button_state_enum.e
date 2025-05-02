note
	description: "Button state enumeration accessible via ${EL_SHARED_BUTTON_STATE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-01 16:38:01 GMT (Thursday 1st May 2025)"
	revision: "7"

class
	EL_BUTTON_STATE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as default_translater
		end

create
	make

feature -- Access

	depressed: NATURAL_8

	highlighted: NATURAL_8

	normal: NATURAL_8
end