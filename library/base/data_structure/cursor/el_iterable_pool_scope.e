note
	description: "[
		Iterable **across** loop scope during which a object can be borrowed from a pool factory and
		then automatically returned after the first and only iteration.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 19:35:46 GMT (Monday 22nd November 2021)"
	revision: "1"

class
	EL_ITERABLE_POOL_SCOPE [G]

inherit
	ITERABLE [G]

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
		end

feature -- Access

	new_cursor: EL_POOL_SCOPE_CURSOR [G]
		do
			create Result.make (pool)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

end