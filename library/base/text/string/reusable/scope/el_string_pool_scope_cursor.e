note
	description: "[
		Artificial scope defined by an **across** loop in which strings can be borrowed from a pool
		See class [$source EL_STRING_POOL_SCOPE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-07 18:08:26 GMT (Tuesday 7th December 2021)"
	revision: "3"

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