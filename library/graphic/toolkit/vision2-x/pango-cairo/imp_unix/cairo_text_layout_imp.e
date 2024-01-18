note
	description: "Unix implementation of ${CAIRO_TEXT_LAYOUT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:30:11 GMT (Sunday 5th November 2023)"
	revision: "4"

class
	CAIRO_TEXT_LAYOUT_IMP

inherit
	CAIRO_TEXT_LAYOUT_I

	EL_UNIX_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	update_preferred_families
		do
		end

end