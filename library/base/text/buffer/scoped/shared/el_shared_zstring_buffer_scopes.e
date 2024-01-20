note
	description: "[
		Shared instances of reusable string buffers for type ${ZSTRING} accessible
		via **across** loop scope.
	]"
	notes: "[
		Usage pattern:
		
			across String_scope as scope loop
				if attached scope.item as str then
					...
				end
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "2"

deferred class
	EL_SHARED_ZSTRING_BUFFER_SCOPES

inherit
	EL_ANY_SHARED

	EL_SHARED_STRING_POOLS

feature {NONE} -- Constants

	String_scope: EL_BORROWED_STRING_SCOPE [ZSTRING, EL_BORROWED_ZSTRING_CURSOR]
		-- defines across loop scope in which a single `ZSTRING' buffer can be borrowed
		-- and automatically reclaimed on loop exit
		once
			create Result.make (Shared_string_pool)
		end

	String_pool_scope: EL_STRING_POOL_SCOPE [ZSTRING]
		-- defines across loop scope in which multiple `ZSTRING' buffers can be borrowed
		-- and automatically reclaimed on loop exit
		once
			create Result.make (Shared_string_pool)
		end

end