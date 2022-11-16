note
	description: "Rules list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	RULES_LIST_PARAMETER

inherit
	LIST_PARAMETER [LIST [ZSTRING]]
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
			extend (node.to_string.split_list (','))
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent add_rules]
			>>)
		end

end