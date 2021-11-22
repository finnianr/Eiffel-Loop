note
	description: "Provide access to pools of reusable strings using across loop scopes"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-22 20:05:59 GMT (Monday 22nd November 2021)"
	revision: "4"

class
	EL_REUSEABLE_STRINGS

create
	make

feature {NONE} -- Initialization

	make
		local
			pool: EL_STRING_FACTORY_POOL [ZSTRING]
			pool_8: EL_STRING_FACTORY_POOL [STRING_8]
			pool_32: EL_STRING_FACTORY_POOL [STRING_32]
		do
			create pool.make (7)
			create string.make (pool)
			create string_pool.make (pool)

			create pool_8.make (7)
			create string_8.make (pool_8)
			create string_8_pool.make (pool_8)

			create pool_32.make (7)
			create string_32.make (pool_32)
			create string_32_pool.make (pool_32)
		end

feature -- Access

	string_8_pool: EL_STRING_POOL_SCOPE [STRING_8]
		-- defines scope in which multiple strings can be borrowed and automatically reclaimed

	string_32_pool: EL_STRING_POOL_SCOPE [STRING_32]
		-- defines scope in which multiple strings can be borrowed and automatically reclaimed

	string_pool: EL_STRING_POOL_SCOPE [ZSTRING]
		-- defines scope in which multiple strings can be borrowed and automatically reclaimed

	string: EL_BORROWED_STRING_SCOPE [ZSTRING]
		-- access to pool of reusable `ZSTRING'

	string_8: EL_BORROWED_STRING_SCOPE [STRING_8]
		-- access to pool of reusable `STRING_8'

	string_32: EL_BORROWED_STRING_SCOPE [STRING_32];
		-- access to pool of reusable `STRING_32'

note
	notes: "[
		**Borrow One String**

			across Reuseable.string as reuse loop
				s1 := reuse.item
				assert ("is empty", s1.is_empty)
				s1.append_string_general ("abc")
			end

		The loop exits after a single iteration and returns **reuse.item** to the pool

		**Borrow Multiple Strings**

			across Reuseable.string_pool as pool loop
				s1 := pool.borrow_item
				assert ("is empty", s1.is_empty)
				s1.append_string_general ("abc")
				s2 := pool.borrow_item
			end

		Both s1 and s2 are returned to pool when **across** loop scope finishes
	]"

end