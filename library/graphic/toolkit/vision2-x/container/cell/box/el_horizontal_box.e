note
	description: "Horizontal box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-30 12:38:45 GMT (Wednesday 30th September 2020)"
	revision: "7"

class
	EL_HORIZONTAL_BOX

inherit
	EL_BOX
		undefine
			fill, item, is_in_default_state, is_equal, prune_all, extend, put, replace
		redefine
			implementation
		end

	EV_HORIZONTAL_BOX
		redefine
			implementation
		end

create
	default_create, make, make_unexpanded, make_centered

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

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_HORIZONTAL_BOX_I
			-- Responsible for interaction with native graphics toolkit.

end