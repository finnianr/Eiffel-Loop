note
	description: "Pool cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-17 17:21:26 GMT (Wednesday 17th November 2021)"
	revision: "1"

deferred class
	EL_POOL_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

feature {NONE} -- Initialization

	make
		do
			if attached once_pool as pool then
				if pool.is_empty then
					create item.make (0)
				else
					item := pool.item
					pool.remove
					item.keep_head (0)
				end
			end
		end

feature -- Access

	item: S

feature -- Status query

	after: BOOLEAN

feature -- Cursor movement

	forth
		do
			after := True
			once_pool.put (item)
		end

feature {NONE} -- Implementation

	once_pool: ARRAYED_STACK [S]
		deferred
		end

end