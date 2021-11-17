note
	description: "Factory for objects conforming to [$source EL_POOL_CURSOR [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-17 17:40:01 GMT (Wednesday 17th November 2021)"
	revision: "1"

class
	EL_POOL_CURSOR_FACTORY [S -> STRING_GENERAL create make end, P -> EL_POOL_CURSOR [S] create make end]

inherit
	ITERABLE [S]

feature -- Access

	new_cursor: P
		do
			create Result.make
		end

end