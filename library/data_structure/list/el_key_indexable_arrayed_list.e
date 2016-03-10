note
	description: "Summary description for {EL_INDEXED_ARRAYED_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_KEY_INDEXABLE_ARRAYED_LIST [G -> EL_KEY_IDENTIFIABLE]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			make, extend, replace, remove
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create index_by_key.make (n)
		end

feature -- Access

	index_by_key: HASH_TABLE [G, NATURAL]

feature -- Element change

	extend (a_item: like first)
		do
			assign_key (a_item)
			Precursor (a_item)
			index_by_key.extend (a_item, a_item.key)
		end

	remove
		do
			index_by_key.remove (item.key)
			Precursor
		end

	replace (a_item: like first)
		local
			old_item_key: NATURAL
		do
			assign_key (a_item)
			old_item_key := item.key
			Precursor (a_item)
			index_by_key.put (a_item, a_item.key)
			if index_by_key.inserted then
				index_by_key.remove (old_item_key)
			else
				index_by_key.force (a_item, a_item.key)
			end
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
