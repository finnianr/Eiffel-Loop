note
	description: "Factory to create items conforming to ${ARRAYED_LIST [ANY]}"
	notes: "[
		A factory to create an instance of this factory for a type conforming to ${ARRAYED_LIST [ANY]}
		is accessible via ${EL_SHARED_FACTORIES}.Arrayed_list_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-11 9:10:53 GMT (Wednesday 11th September 2024)"
	revision: "9"

class
	EL_ARRAYED_LIST_FACTORY [G -> ARRAYED_LIST [ANY] create make end]

inherit
	EL_FACTORY [G]
		rename
			new_item as new_empty_item
		end

feature -- Access

	new_empty_item: G
		do
			create Result.make (0)
		end

	new_item (n: INTEGER): G
		do
			create Result.make (n)
		end

end