note
	description: "String list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-26 12:15:26 GMT (Friday 26th November 2021)"
	revision: "5"

class
	STRING_LIST_PARAMETER

inherit
	LIST_PARAMETER [ZSTRING]
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
			node_string: ZSTRING
		do
			node_string := node.to_string
			node_string.prune_all ('%N')
			node_string.split_list ('|').do_all (agent extend)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent extend_from_node]
			>>)
		end

end