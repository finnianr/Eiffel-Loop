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
	date: "2024-04-04 14:51:58 GMT (Thursday 4th April 2024)"
	revision: "7"

class
	EL_ARRAYED_LIST_FACTORY [G -> ARRAYED_LIST [ANY] create make end]

inherit
	EL_FACTORY [G]

feature -- Access

	new_item: G
		do
			create Result.make (0)
		end

end