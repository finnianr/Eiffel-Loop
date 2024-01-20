note
	description: "Factory to create empty strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

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