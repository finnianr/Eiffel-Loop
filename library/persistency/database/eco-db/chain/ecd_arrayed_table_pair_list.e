note
	description: "${ECD_ARRAYED_TUPLE_LIST} that can be initialized from a ${HASH_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 11:58:09 GMT (Thursday 11th July 2024)"
	revision: "1"

class
	ECD_ARRAYED_TABLE_PAIR_LIST [G, K -> HASHABLE]

inherit
	ECD_ARRAYED_TUPLE_LIST [TUPLE [value: G; key: K]]

create
	make, make_default, make_from_file, make_from_table

feature {NONE} -- Initialization

	make_from_table (table: HASH_TABLE [G, K])
		do
			make (table.count)
			from table.start until table.after loop
				extend ([table.item_for_iteration, table.key_for_iteration])
				table.forth
			end
		end
end