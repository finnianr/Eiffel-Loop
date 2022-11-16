note
	description: "[
		Artificial scope defined by an **across** loop in which strings can be borrowed from a pool
		See class [$source EL_STRING_POOL_SCOPE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

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