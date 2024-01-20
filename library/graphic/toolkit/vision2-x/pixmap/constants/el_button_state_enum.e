note
	description: "Button state enumeration accessible via ${EL_SHARED_BUTTON_STATE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	EL_BUTTON_STATE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			foreign_naming as eiffel_naming
		end

create
	make

feature -- Access

	depressed: NATURAL_8

	highlighted: NATURAL_8

	normal: NATURAL_8
end