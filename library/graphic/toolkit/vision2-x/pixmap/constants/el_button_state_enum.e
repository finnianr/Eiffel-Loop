note
	description: "Button state enumeration accessible via [$source EL_SHARED_BUTTON_STATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

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