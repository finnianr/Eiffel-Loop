note
	description: "Button state enumeration accessible via [$source EL_SHARED_BUTTON_STATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:25:33 GMT (Thursday 16th June 2022)"
	revision: "2"

class
	EL_BUTTON_STATE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
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