note
	description: "[
		Iteration cursor defining a scope in which a single item can be borrowed from a factory pool
		and then returned when **across** loop exits after first iteration.
		See class ${EL_BORROWED_OBJECT_SCOPE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 10:29:08 GMT (Wednesday 16th April 2025)"
	revision: "6"

class
	EL_BORROWED_OBJECT_CURSOR [G]

inherit
	ITERATION_CURSOR [G]

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
			item := a_pool.borrowed_item
		end

feature -- Access

	item: G

feature -- Status query

	after: BOOLEAN

feature -- Cursor movement

	forth
		do
			after := True
			pool.recycle (item)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

end