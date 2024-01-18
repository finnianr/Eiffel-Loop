note
	description: "Button state enumeration accessible via ${EL_SHARED_BUTTON_STATE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 12:16:02 GMT (Sunday 16th July 2023)"
	revision: "4"

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