note
	description: "A ${EL_ARRAYED_MAP_LIST} indexed by key conforming to ${COMPARABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_KEY_INDEXED_ARRAYED_MAP_LIST [K -> COMPARABLE, G]

inherit
	EL_ARRAYED_MAP_LIST [K, G]
		redefine
			make
		end

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create index_array.make_empty
		end

feature -- Basic operations

	binary_search (a_item: K)
		do
			if index_array.count /= count then
				sort_by_key (True)
				create index_array.make_from_array (key_list.to_array)
			end
			index_array.binary_search (a_item)
			if index_array.found then
				go_i_th (index_array.found_index)

			elseif count > 0 then

				finish; forth
			end
		end

feature {NONE} -- Internal attributes

	index_array: SORTABLE_ARRAY [K]
end