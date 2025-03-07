note
	description: "String list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-07 12:56:49 GMT (Friday 7th March 2025)"
	revision: "8"

class
	STRING_LIST_PARAMETER

inherit
	LIST_PARAMETER [ZSTRING]
		rename
			display_item as do_nothing
		redefine
			display_all_items
		end

create
	make

feature -- Basic operations

	display_all_items
			--
		do
			log.put_new_line
			log.put_columns (Current, 11, 0)
		end

feature {NONE} -- Build from XML

	extend_from_node
			--
		local
			node_string: ZSTRING
		do
			node_string := node.to_string
			node_string.prune_all ('%N')
			node_string.split_list ('|').do_all (agent extend)
		end

end