note
	description: "Summary description for {STRING_LIST_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	STRING_LIST_PARAMETER

inherit
	LIST_PARAMETER [STRING]
		redefine
			building_action_table, display_item
		end

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_string (item)
			log.put_character (' ')
			if index \\ 12 = 0 then
				log.put_new_line
			end
		end

feature {NONE} -- Build from XML

	extend_from_node
			--
		local
			node_string: STRING
		do
			node_string := node.to_string
			node_string.prune_all ({ASCII}.line_feed.to_character_8)
			node_string.split ('|').do_all (agent extend)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent extend_from_node]
			>>)
		end

end
