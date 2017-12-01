note
	description: "Summary description for {EL_INDEXED_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-24 14:18:02 GMT (Friday 24th November 2017)"
	revision: "3"

deferred class
	EL_KEY_INDEXABLE_ARRAYED_LIST [G -> EL_KEY_IDENTIFIABLE_STORABLE]

inherit
	EL_STORABLE_ARRAYED_LIST [G]
		redefine
			make, extend, replace, on_delete
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create index_by_key.make (n)
		end

feature -- Access

	index_by_key: HASH_TABLE [INTEGER, NATURAL]

feature -- Element change

	extend (a_item: like first)
		do
			assign_key (a_item)
			Precursor (a_item)
			index_by_key.extend (count, a_item.key)
		end

	replace (a_item: like first)
		local
			old_item_key: NATURAL
		do
			assign_key (a_item)
			old_item_key := item.key
			Precursor (a_item)
			index_by_key.put (index, a_item.key)
			if index_by_key.inserted then
				index_by_key.remove (old_item_key)
			else
				index_by_key.force (index, a_item.key)
			end
		end

feature -- Basic operations

	search_by_key (key: NATURAL)
		local
			table: like index_by_key
		do
			table := index_by_key
			table.search (key)
			if table.found then
				index := table.found_item
			else
				index := 0
			end
		end

feature {NONE} -- Event handler

	on_delete
		do
			index_by_key.remove (item.key)
		end

feature {NONE} -- Implementation

	assign_key (a_item: like first)
			-- Assign a new if zero
		do
			if a_item.key = 0 then
				maximum_key := maximum_key + 1
				a_item.set_key (maximum_key)

			elseif a_item.key > maximum_key then
				maximum_key := a_item.key
			end
		end

	maximum_key: NATURAL

end
