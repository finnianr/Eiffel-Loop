note
	description: "Vertical box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_VERTICAL_BOX

inherit
	EL_BOX
		undefine
			fill, item, is_in_default_state, is_equal, prune_all, extend, put, replace
		redefine
			implementation
		end

	EV_VERTICAL_BOX
		undefine
			Default_pixmaps
		redefine
			implementation
		end

create
	default_create, make, make_unexpanded, make_centered

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

feature {EV_ANY, EV_ANY_I} -- Implementation

	implementation: EV_VERTICAL_BOX_I
		-- Responsible for interaction with native graphics toolkit.

end