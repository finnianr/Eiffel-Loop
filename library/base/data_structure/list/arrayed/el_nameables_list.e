note
	description: "List of items conforming to [$source EL_NAMEABLE [READABLE_STRING_GENERAL]] and searchable by item name"
	notes: "[
		Benchmarks show that for small lists the search performance is almost identical to a hash table.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-28 18:19:53 GMT (Sunday 28th February 2021)"
	revision: "3"

class
	EL_NAMEABLES_LIST [G -> EL_NAMEABLE [READABLE_STRING_GENERAL]]

inherit
	EL_ARRAYED_LIST [G]
		rename
			make as make_with_count,
			search as item_search,
			item as found_item
		export
			{NONE} all
			{ANY} found_item
		end

create
	make

feature {NONE} -- Initialization

	make (array: ARRAY [G])
		local
			l_found: BOOLEAN
		do
			if array.is_empty then
				create index_array.make_empty
			else
				create index_array.make_filled (array.item (1).name, 1, array.count)
			end
			index_array.sort
			make_with_count (array.count)
			across index_array as name loop
				l_found := False
				across array as named until found loop
					if named.item.name ~ name.item then
						extend (named.item)
						l_found := True
					end
				end
			end
		ensure then
			indexed: across index_array as name all i_th (name.cursor_index).name ~ name.item end
		end

feature -- Status query

	has_name (name: like found_item.name): BOOLEAN
		do
			search (name)
			Result := found
		end

feature -- Cursor movement

	search (name: like found_item.name)
		do
			index_array.binary_search (name)
			if index_array.found then
				go_i_th (index_array.found_index)
			else
				finish; forth
			end
		end

feature {NONE} -- Internal attributes

	index_array: SORTABLE_ARRAY [like found_item.name]
end