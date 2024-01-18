note
	description: "Factory to create empty strings conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 18:48:52 GMT (Tuesday 6th December 2022)"
	revision: "3"

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