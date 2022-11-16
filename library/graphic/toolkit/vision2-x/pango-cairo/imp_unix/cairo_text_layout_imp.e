note
	description: "Unix implementation of [$source CAIRO_TEXT_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	CAIRO_TEXT_LAYOUT_IMP

inherit
	CAIRO_TEXT_LAYOUT_I

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	update_preferred_families
		do
		end

end