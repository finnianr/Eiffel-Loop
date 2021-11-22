note
	description: "[
		Defines an **across** loop scope in which a resource can be borrowed from a factory pool and then
		automatically returned after the first and only iteration of the cursor.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 19:33:04 GMT (Monday 22nd November 2021)"
	revision: "1"

class
	EL_BORROWED_OBJECT_SCOPE [G]

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

	new_cursor: EL_BORROWED_OBJECT_CURSOR [G]
		do
			create Result.make (pool)
		end

feature {NONE} -- Internal attributes

	pool: EL_FACTORY_POOL [G]

end