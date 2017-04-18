note
	description: "Summary description for {EL_HORIZONTAL_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-28 11:51:45 GMT (Saturday 28th January 2017)"
	revision: "2"

class
	EL_HORIZONTAL_BOX

inherit
	EL_BOX
		rename
			implementation as box_implementation
		undefine
			fill, item, is_in_default_state, is_equal, prune_all, extend, put, replace
		end

	EV_HORIZONTAL_BOX
		select
			implementation
		end

create
	default_create, make, make_unexpanded

feature {NONE} -- Implementation

	cms_to_pixels (cms: REAL): INTEGER
			-- centimeters to pixels conversion according to box orientation
		do
			Result := Screen.horizontal_pixels (cms)
		end

	set_last_size (size: INTEGER)
			--
		do
			last.set_minimum_width (size)
		end

end
