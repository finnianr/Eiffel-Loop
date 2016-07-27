note
	description: "Summary description for {URL_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-15 8:53:22 GMT (Tuesday 15th December 2015)"
	revision: "4"

class
	URL_PARAMETER

inherit
	STRING_PARAMETER
		rename
			item as url,
			set_item_from_node as set_url_from_node
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
			log.put_string_field ("url", url)
			log.put_new_line
		end

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["text()", agent set_url_from_node]
			>>)
		end

end