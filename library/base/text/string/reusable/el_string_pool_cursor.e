note
	description: "[
		Cursor to use an **across** loop as an artificial scope in which a temporary string buffer
		conforming to [$source STRING_GENERAL] can be borrowed from a shared pool. After iterating
		just once the scope finishes and the buffer item is automatically returned to the shared `pool'
		stack.
	]"
	notes: "[
		See `[$source GENERAL_TEST_SET].test_reusable_strings' for an example
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-19 19:34:19 GMT (Friday 19th November 2021)"
	revision: "2"

class
	EL_STRING_POOL_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
			if a_pool.is_empty then
				create item.make (0)
			else
				item := a_pool.item
				a_pool.remove
				item.keep_head (0)
			end
		end

feature -- Access

	item: S

	copied_item (general: READABLE_STRING_GENERAL): S
		do
			Result := item
			Result.append (general)
		end

feature -- Status query

	after: BOOLEAN

feature -- Cursor movement

	forth
		do
			after := True
			pool.put (item)
		end

feature {NONE} -- Internal attributes

	pool: ARRAYED_STACK [S]

end