note
	description: "Summary description for {REAL_RANGE_LIST_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	REAL_RANGE_LIST_PARAMETER

inherit
	LIST_PARAMETER [ARRAYED_LIST [REAL]]
		redefine
			building_action_table, display_item
		end

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_string ("Real range [")
			log.put_real (index)
			log.put_string ("]: ")
			from item.start until item.after loop
				log.put_real (item.item)
				log.put_string (" ")
				item.forth
			end
			log.put_new_line
		end

feature {NONE} -- Implementation

	last_real_range: like item

feature {NONE} -- Build from XML

	add_real_range
			--
		local
			node_string: STRING
		do
			node_string := node.to_string
			create last_real_range.make (node_string.occurrences (',') + 1)
			node_string.split (',').do_all (
				agent (str: STRING)
					do
						last_real_range.extend (str.to_real)
					end
			)
			extend (last_real_range)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent add_real_range]
			>>)
		end

end
