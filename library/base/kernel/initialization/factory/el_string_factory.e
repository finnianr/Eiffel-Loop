note
	description: "Factory to create empty strings conforming to ${READABLE_STRING_GENERAL}"
	notes: "[
		A factory to create an instance of this factory for a type conforming to
		${READABLE_STRING_GENERAL} is accessible via ${EL_SHARED_FACTORIES}.String_factory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 14:59:37 GMT (Thursday 4th April 2024)"
	revision: "5"

class
	EL_STRING_FACTORY [S -> READABLE_STRING_GENERAL create make_empty end]

inherit
	EL_FACTORY [S]

feature -- Access

	new_item: S
		do
			create Result.make_empty
		end

end