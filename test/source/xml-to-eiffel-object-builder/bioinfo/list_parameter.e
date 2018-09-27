note
	description: "List parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	LIST_PARAMETER [G]

inherit
	PARAMETER
		rename
			display_item as display_all_items
		undefine
			copy, is_equal
		redefine
			make, display_all_items
		end

	ARRAYED_LIST [G]
		rename
			make as make_list
		end

	EL_MODULE_LOG
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
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
			log.put_new_line
		end

	display_item
			--
		deferred
		end

end