note
	description: "Rules list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 15:07:29 GMT (Saturday 24th June 2023)"
	revision: "7"

class
	RULES_LIST_PARAMETER

inherit
	LIST_PARAMETER [LIST [ZSTRING]]
		rename
			extend_from_node as add_rules
		redefine
			display_item
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

end