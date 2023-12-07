note
	description: "Real parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-07 16:27:53 GMT (Thursday 7th December 2023)"
	revision: "7"

class
	REAL_PARAMETER

inherit
	TEXT_NODE_PARAMETER [REAL]

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_real_field (" value", item, Void)
			log.put_new_line
		end

feature {NONE} -- Build from XML

	set_item_from_node
		do
			item := node
		end

end