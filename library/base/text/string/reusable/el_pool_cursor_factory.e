note
	description: "Factory for objects conforming to [$source EL_POOL_CURSOR [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-19 18:15:20 GMT (Friday 19th November 2021)"
	revision: "2"

class
	EL_POOL_CURSOR_FACTORY [S -> STRING_GENERAL create make end]

inherit
	ITERABLE [S]

create
	make

feature {NONE} -- Initialization

	make
		do
			create pool.make (5)
		end

feature -- Access

	new_cursor: EL_STRING_POOL_CURSOR [S]
		do
			create Result.make (pool)
		end

feature {NONE} -- Internal attributes

	pool: ARRAYED_STACK [S]

end