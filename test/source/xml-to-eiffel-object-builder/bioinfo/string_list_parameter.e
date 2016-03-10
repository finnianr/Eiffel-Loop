note
	description: "Summary description for {STRING_LIST_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	STRING_LIST_PARAMETER

inherit
	LIST_PARAMETER [ASTRING]
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
		do
			node.to_string.translated (once "%N", once "%U").split ('|').do_all (agent extend)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent extend_from_node]
			>>)
		end

end
