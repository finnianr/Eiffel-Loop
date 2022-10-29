note
	description: "[
		Defines an **across** loop scope in which a string conforming to [$source STRING_GENERAL] can be borrowed
		from a factory pool and then automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 10:30:54 GMT (Saturday 29th October 2022)"
	revision: "7"

class
	EL_BORROWED_STRING_SCOPE [
		S -> STRING_GENERAL create make end, C -> EL_BORROWED_STRING_CURSOR [S] create make end
	]

inherit
	EL_BORROWED_OBJECT_SCOPE [S]
		redefine
			new_cursor
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			create {EL_STRING_FACTORY_POOL [S]} pool.make (8)
		end

feature -- Access

	new_cursor: C
		do
			create Result.make (Current)
		end

	new_pool_scope: EL_STRING_POOL_SCOPE [S]
		do
			create Result.make (pool)
		end

end