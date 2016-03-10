note
	description: "Summary description for {EL_AUTO_CELL_HIDING_VERTICAL_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_AUTO_CELL_HIDING_VERTICAL_BOX

inherit
	EL_AUTO_CELL_HIDING_BOX
		rename
			implementation as hiding_box_implementation
		undefine
			fill, item, is_in_default_state, is_equal, prune_all, extend, put, replace, internal_remove, internal_merge_right
		end

	EL_VERTICAL_BOX
		rename
			remove as internal_remove, merge_right as internal_merge_right, Screen as Mod_screen
		undefine
			make
		select
			implementation
		end


create
	default_create, make

end
