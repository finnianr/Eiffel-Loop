note
	description: "[
		Assigns values to storable items conforming to [$source EL_KEY_IDENTIFIABLE_STORABLE],
		and augments classes [$source ECD_ARRAYED_LIST] and [$source ECD_REFLECTIVE_RECOVERABLE_CHAIN]
		with a primary key index.
	]"
	instructions: "[
		Inherit this class in parallel with class inheriting [$source ECD_ARRAYED_LIST] and undefine
		the routine `assign_key' as in this example:

			deferred class
				CUSTOMER_LIST

			inherit
				ECD_REFLECTIVE_ARRAYED_LIST [CUSTOMER]
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
	date: "2021-05-24 13:07:34 GMT (Monday 24th May 2021)"
	revision: "6"

deferred class
	ECD_PRIMARY_KEY_INDEXABLE [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

feature {NONE} -- Initialization

	make_index_by_key (index_list: BAG [ECD_INDEX_TABLE [G, HASHABLE]])
		do
			create index_by_key.make (current_list, capacity)
			index_list.extend (index_by_key)
		end

feature -- Access

	index_by_key: ECD_KEY_INDEX [G]

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

	current_list: ECD_ARRAYED_LIST [G]
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