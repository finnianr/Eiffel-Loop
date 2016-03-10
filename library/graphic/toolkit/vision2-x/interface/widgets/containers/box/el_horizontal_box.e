note
	description: "Summary description for {EL_HORIZONTAL_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

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
	default_create, make

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
