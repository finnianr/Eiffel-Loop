note
	description: "[
		Defines an **across** loop scope in which a string conforming to [$source STRING_GENERAL] can be borrowed
		from a factory pool and then automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 9:45:32 GMT (Wednesday 8th November 2023)"
	revision: "10"

class
	EL_BORROWED_STRING_SCOPE [
		S -> STRING_GENERAL create make end, C -> EL_BORROWED_STRING_CURSOR [S] create make end
	]

inherit
	ITERABLE [S]

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
		end

feature -- Access

	new_cursor: C
		do
			create Result.make (pool)
		end

feature {EL_BORROWED_STRING_CURSOR} -- Internal attributes

	pool: EL_STRING_POOL [S]

end