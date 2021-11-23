note
	description: "Provide access to pools of reusable strings using across loop scopes"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 11:14:21 GMT (Tuesday 23rd November 2021)"
	revision: "5"

class
	EL_REUSEABLE_STRINGS

create
	make

feature {NONE} -- Initialization

	make
		do
			create string.make_default
			string_8_pool := string_8.new_pool_scope

			create string_8.make_default
			string_8_pool := string_8.new_pool_scope

			create string_32.make_default
			string_32_pool := string_32.new_pool_scope
		end

feature -- Pool scopes

	string_8_pool: EL_STRING_POOL_SCOPE [STRING_8]
		-- defines scope in which multiple strings can be borrowed and automatically reclaimed

	string_32_pool: EL_STRING_POOL_SCOPE [STRING_32]
		-- defines scope in which multiple strings can be borrowed and automatically reclaimed

	string_pool: EL_STRING_POOL_SCOPE [ZSTRING]
		-- defines scope in which multiple strings can be borrowed and automatically reclaimed

feature -- String scopes

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

		Both s1 and s2 are returned to pool when **across** loop scope finishes.

		**GC Overhead**

		''Reuseable.string'' has less GC overhead then ''Reuseable.string_pool'' as it does
		not create a lending list array.
	]"

end