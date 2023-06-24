note
	description: "Real range list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 15:07:10 GMT (Saturday 24th June 2023)"
	revision: "7"

class
	REAL_RANGE_LIST_PARAMETER

inherit
	LIST_PARAMETER [ARRAYED_LIST [REAL]]
		rename
			extend_from_node as add_real_range
		redefine
			display_item
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
			real_list: EL_ZSTRING_LIST
		do
			create real_list.make_split (node.to_string, ',')
			create last_real_range.make (real_list.count)
			across real_list as str loop
				last_real_range.extend (str.item.to_real)
			end
			extend (last_real_range)
		end

end