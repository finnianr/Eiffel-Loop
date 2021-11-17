note
	description: "Provide access to pools of reusable strings using across loop scopes"
	notes: "[
		**Use Pattern**
		
			across Reuseable.string as reuse loop
				s1 := reuse.item
				assert ("is empty", s1.is_empty)
				s1.append_string_general ("abc")
			end
			
		The loop exits after a single iteration and returns **reuse.item** to the pool

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-17 17:58:23 GMT (Wednesday 17th November 2021)"
	revision: "1"

class
	EL_REUSEABLE_STRINGS

create
	make

feature {NONE} -- Initialization

	make
		do
			create string
			create string_8
			create string_32
		end

feature -- Access

	string: EL_POOL_CURSOR_FACTORY [ZSTRING, EL_ZSTRING_POOL_CURSOR]
		-- access to pool of reusable `ZSTRING'

	string_8: EL_POOL_CURSOR_FACTORY [STRING_8, EL_STRING_8_POOL_CURSOR]
		-- access to pool of reusable `STRING_8'

	string_32: EL_POOL_CURSOR_FACTORY [STRING_32, EL_STRING_32_POOL_CURSOR]
		-- access to pool of reusable `STRING_32'

end