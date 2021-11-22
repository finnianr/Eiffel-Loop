note
	description: "[
		Iteration cursor defining a scope in which items can be borrowed from a pool
		and then all returned when **across* loop exits after first iteration.
		See class [$source EL_ITERABLE_POOL_SCOPE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 19:06:41 GMT (Monday 22nd November 2021)"
	revision: "1"

class
	EL_POOL_SCOPE_CURSOR [G]

inherit
	ITERATION_CURSOR [G]
		rename
			item as borrowed_item,
			forth as end_scope
		end

create
	make

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
			create lending_list.make (10)
		end

feature -- Access

	borrowed_item: G
		do
			Result := pool.borrowed_item
			lending_list.extend (Result)
		end

feature -- Status query

	after: BOOLEAN

feature -- Cursor movement

	start_scope
		do
			after := False
			lending_list.wipe_out
		end

	end_scope
		do
			after := True
			lending_list.do_all (agent pool.recycle)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

	lending_list: ARRAYED_LIST [G]

end