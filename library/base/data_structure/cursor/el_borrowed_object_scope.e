note
	description: "[
		Defines an across-loop scope in which a resource can be borrowed from a factory pool and then
		automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-24 8:36:49 GMT (Sunday 24th April 2022)"
	revision: "4"

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