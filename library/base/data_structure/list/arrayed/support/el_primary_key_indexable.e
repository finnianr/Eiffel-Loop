note
	description: "[
		Augments classes [$source EL_STORABLE_LIST] and [$source EL_REFLECTIVELY_STORABLE_LIST]
		with a primary key index.
	]"
	instructions: "[
		Inherit this class in parallel with class inheriting [$source EL_STORABLE_LIST] and undefine
		the routine `assign_key' as in this example:

			deferred class
				CUSTOMER_LIST

			inherit
				EL_REFLECTIVELY_STORABLE_LIST [CUSTOMER]
					undefine
						assign_key
					end

				KEY_INDEXABLE [CUSTOMER]
					undefine
						is_equal, copy
					end
					
		Values for the storable primary key will be generated automatically.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-22 15:27:39 GMT (Thursday 22nd February 2018)"
	revision: "3"

deferred class
	EL_PRIMARY_KEY_INDEXABLE [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

feature {NONE} -- Initialization

	make_index_by_key (index_list: BAG [EL_STORABLE_LIST_INDEX [G, HASHABLE]])
		do
			create index_by_key.make (current_list, capacity)
			index_list.extend (index_by_key)
		end

feature -- Access

	index_by_key: EL_STORABLE_KEY_INDEX [G]

	item_by_key (key: NATURAL): G
		local
			l_index: like index_by_key
		do
			l_index := index_by_key
			l_index.search (key)
			if l_index.found then
				Result := l_index.found_item
			else
				create Result.make_default
			end
		end

feature -- Element change

	key_delete (key: NATURAL)
		require
			has_key: index_by_key.has_key (key)
		do
			index_by_key.list_search (key)
			if found then
				delete
			end
		end

	key_replace (a_item: G)
		require
			has_key: index_by_key.has_key (a_item.key)
		do
			index_by_key.list_search (a_item.key)
			if found then
				replace (a_item)
			end
		end

feature {NONE} -- Implementation

	assign_key (identifiable: EL_KEY_IDENTIFIABLE_STORABLE)
			-- Assign a new if zero
		do
			if identifiable.key = 0 then
				maximum_key := maximum_key + 1
				identifiable.set_key (maximum_key)

			elseif identifiable.key > maximum_key then
				maximum_key := identifiable.key
			end
		end

	capacity: INTEGER
		deferred
		end

	current_list: EL_STORABLE_LIST [G]
		deferred
		end

	delete
		deferred
		end

	found: BOOLEAN
		deferred
		end

	replace (a_item: G)
		deferred
		end

feature {NONE} -- Internal attributes

	maximum_key: NATURAL

end
