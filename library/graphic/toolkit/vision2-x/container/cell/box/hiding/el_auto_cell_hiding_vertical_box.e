note
	description: "Auto cell hiding vertical box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-31 14:19:25 GMT (Monday 31st August 2020)"
	revision: "7"

class
	EL_AUTO_CELL_HIDING_VERTICAL_BOX

inherit
	EL_AUTO_CELL_HIDING_BOX
		rename
			implementation as hiding_box_implementation
		undefine
			fill, item, is_in_default_state, is_equal, prune_all, extend, put, replace,
			internal_remove, internal_merge_right
		end

	EL_VERTICAL_BOX
		rename
			remove as internal_remove, merge_right as internal_merge_right
		undefine
			make
		select
			implementation
		end


create
	default_create, make

end
