note
	description: "[
		Defines an **across** loop scope in which multiple strings can be borrowed from a shared pool
		and automatically returned when the loop exits after first and only iteration
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_STRING_POOL_SCOPE [S -> STRING_GENERAL create make end]

inherit
	EL_ITERABLE_POOL_SCOPE [S]
		redefine
			new_cursor
		end

create
	make

feature -- Access

	new_cursor: EL_STRING_POOL_SCOPE_CURSOR [S]
		do
			create Result.make (pool)
		end

end