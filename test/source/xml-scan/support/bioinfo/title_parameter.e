note
	description: "Title parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 14:58:43 GMT (Saturday 18th March 2023)"
	revision: "6"

class
	TITLE_PARAMETER

inherit
	STRING_PARAMETER
		rename
			item as title,
			set_item_from_node as set_title_from_node
		redefine
			building_action_table, display_item
		end

create
	make

feature {NONE} -- Implementation

	display_item
			--
		do
			log.put_new_line
			log.put_string_field_to_max_length ("title", title, 200)
			log.put_new_line
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent set_title_from_node]
			>>)
		end

end