note
	description: "Vertical box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 7:51:40 GMT (Friday 21st December 2018)"
	revision: "6"

class
	EL_VERTICAL_BOX

inherit
	EL_BOX
		rename
			implementation as box_implementation
		undefine
			fill, item, is_in_default_state, is_equal, prune_all, extend, put, replace
		end

	EV_VERTICAL_BOX
		select
			implementation
		end

create
	default_create, make, make_unexpanded

feature {NONE} -- Implementation

	set_last_size (size: INTEGER)
			--
		do
			last.set_minimum_height (size)
		end

	cms_to_pixels (cms: REAL): INTEGER
			-- centimeters to pixels conversion according to box orientation
		do
			Result := Screen.vertical_pixels (cms)
		end

end
