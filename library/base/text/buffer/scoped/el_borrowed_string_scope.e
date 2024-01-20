note
	description: "[
		Defines an **across** loop scope in which a string conforming to ${STRING_GENERAL} can be borrowed
		from a factory pool and then automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "11"

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