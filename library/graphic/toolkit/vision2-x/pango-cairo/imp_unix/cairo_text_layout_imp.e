note
	description: "Unix implementation of [$source CAIRO_TEXT_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-04 11:03:05 GMT (Tuesday 4th August 2020)"
	revision: "2"

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
