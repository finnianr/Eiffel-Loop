note
	description: "Integer parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 14:54:29 GMT (Saturday 24th June 2023)"
	revision: "6"

class
	INTEGER_PARAMETER

inherit
	TEXT_NODE_PARAMETER [INTEGER]

create
	make

feature -- Basic operations

	display_item
			--
		do
			log.put_integer_field (" value", item)
			log.put_new_line
		end

feature {NONE} -- Build from XML

	set_item_from_node
		do
			item := node
		end

end