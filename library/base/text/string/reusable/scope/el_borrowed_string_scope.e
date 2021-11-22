note
	description: "[
		Defines an **across** loop scope in which a string conforming to [$source STRING_GENERAL] can be borrowed
		from a factory pool and then automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 19:58:40 GMT (Monday 22nd November 2021)"
	revision: "4"

class
	EL_BORROWED_STRING_SCOPE [S -> STRING_GENERAL create make end]

inherit
	EL_BORROWED_OBJECT_SCOPE [S]
		redefine
			new_cursor
		end

create
	make

feature -- Access

	new_cursor: EL_BORROWED_STRING_CURSOR [S]
		do
			create Result.make (pool)
		end

end