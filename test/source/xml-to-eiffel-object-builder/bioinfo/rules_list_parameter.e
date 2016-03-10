note
	description: "Summary description for {RULES_LIST_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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
