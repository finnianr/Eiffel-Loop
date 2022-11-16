note
	description: "[
		Defines an across-loop scope in which a resource can be borrowed from a factory pool and then
		automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_BORROWED_OBJECT_SCOPE [G]

inherit
	EL_ITERABLE_SCOPE [G]

create
	make, make_with_agent

feature {NONE} -- Initialization

	make (a_pool: like pool)
		do
			pool := a_pool
		end

	make_with_agent (a_new_item: FUNCTION [G])
		do
			create {EL_AGENT_FACTORY_POOL [G]} pool.make (5, a_new_item)
		end

feature {NONE} -- Implementation

	new_item: G
		do
			Result := pool.borrowed_item
		end

	on_exit (item: G)
		do
			pool.recycle (item)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

end