note
	description: "[
		Assigns values to storable items conforming to ${EL_KEY_IDENTIFIABLE_STORABLE},
		and augments classes ${ECD_ARRAYED_LIST} and ${ECD_REFLECTIVE_RECOVERABLE_CHAIN}
		with a primary key index.
	]"
	instructions: "[
		Inherit this class in parallel with class inheriting ${ECD_ARRAYED_LIST} and undefine
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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

deferred class
	ECD_PRIMARY_KEY_INDEXABLE [G -> EL_KEY_IDENTIFIABLE_STORABLE create make_default end]

feature {NONE} -- Initialization

	create_index_tables
		do
			create key_index.make (current_list)
		end

feature -- Access

	key_index: ECD_KEY_INDEX [G]

	item_by_key (key: NATURAL): G
		local
			l_index: like key_index
		do
			l_index := key_index
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
			has_key: key_index.has_key (key)
		do
			key_index.list_search (key)
			if found then
				delete
			end
		end

	key_replace (a_item: G)
		require
			has_key: key_index.has_key (a_item.key)
		do
			key_index.list_search (a_item.key)
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