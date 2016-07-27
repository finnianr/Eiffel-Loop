note
	description: "Summary description for {EL_INDEXED_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-02-12 13:57:20 GMT (Friday 12th February 2016)"
	revision: "5"

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

	default_item: G
		deferred
		end

	index_by_key: HASH_TABLE [INTEGER, NATURAL]

	indexed_item (key: NATURAL): like item
		local
			l_index: INTEGER
		do
			l_index := index_by_key [key]
			if l_index > 0 then
				Result := i_th (l_index)
			else
				Result := default_item
			end
		end

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