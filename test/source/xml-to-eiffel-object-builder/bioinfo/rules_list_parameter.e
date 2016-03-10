note
	description: "Summary description for {RULES_LIST_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	RULES_LIST_PARAMETER

inherit
	LIST_PARAMETER [LIST [STRING]]
		redefine
			building_action_table, display_item
		end

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_string ("Rule set [")
			log.put_integer (index)
			log.put_string ("]: ")
			from item.start until item.after loop
				log.put_string (item.item)
				log.put_string (" ")
				item.forth
			end
			log.put_new_line
		end

feature {NONE} -- Build from XML

	add_rules
			--
		do
			extend (node.to_string.split (','))
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent add_rules]
			>>)
		end

end
