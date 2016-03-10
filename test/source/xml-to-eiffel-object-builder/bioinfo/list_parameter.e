note
	description: "Summary description for {LIST_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	LIST_PARAMETER [G]

inherit
	PARAMETER
		rename
			display_item as display_all_items
		undefine
			copy, is_equal
		redefine
			default_create, display_all_items
		end

	ARRAYED_LIST [G]
		rename
			make as make_list
		undefine
			default_create
		end

	EL_MODULE_LOG
		undefine
			default_create, copy, is_equal
		end

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor {PARAMETER}
			make_list (50)
		end

feature -- Basic operations

	display_all_items
			--
		do
			log.put_new_line
			from start until after loop
				display_item
				forth
			end
		end

	display_item
			--
		deferred
		end

end
