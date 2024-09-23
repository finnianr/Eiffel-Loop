note
	description: "Factory to create items conforming to ${ARRAYED_LIST}"
	notes: "[
		A factory to create an instance of this factory for a type conforming to ${ARRAYED_LIST [ANY]}
		is accessible via ${EL_SHARED_FACTORIES}.Arrayed_list_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 8:04:32 GMT (Monday 23rd September 2024)"
	revision: "10"

class
	EL_HASH_TABLE_FACTORY [G -> HASH_TABLE [ANY, HASHABLE] create make, make_equal end]

inherit
	EL_FACTORY [G]
		rename
			new_item as new_default_item
		export
			{NONE} all
		end

feature -- Access

	new_equal_item (n: INTEGER): G
		do
			create Result.make_equal (n)
		end

	new_item (n: INTEGER): G
		do
			create Result.make (n)
		end

	new_default_item: G
		do
			Result := new_equal_item (0)
		end
end