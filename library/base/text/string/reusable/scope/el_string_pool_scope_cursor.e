note
	description: "[
		Artificial scope defined by an **across** loop in which strings can be borrowed from a pool
		See class [$source EL_STRING_POOL_SCOPE_CURSOR_FACTORY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 19:58:48 GMT (Monday 22nd November 2021)"
	revision: "2"

class
	EL_STRING_POOL_SCOPE_CURSOR [S -> STRING_GENERAL create make end]

inherit
	EL_POOL_SCOPE_CURSOR [S]

create
	make

feature -- Access

	filled_borrowed_item (general: READABLE_STRING_GENERAL): S
		do
			Result := borrowed_item
			Result.append (general)
		end

end