note
	description: "[
		Defines an **across** loop scope in which a resource can be borrowed from a factory pool and then
		automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 10:48:31 GMT (Tuesday 23rd November 2021)"
	revision: "2"

class
	EL_BORROWED_OBJECT_SCOPE [G]

inherit
	ITERABLE [G]

create
	make, make_with_agent

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
		end

	make_with_agent (new_item: FUNCTION [G])
		do
			create {EL_AGENT_FACTORY_POOL [G]} pool.make (5, new_item)
		end

feature -- Access

	new_cursor: EL_BORROWED_OBJECT_CURSOR [G]
		do
			create Result.make (pool)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

end