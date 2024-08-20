note
	description: "[
		Shared instances of reusable string buffers for type ${STRING_8} accessible
		via **across** loop scope.
	]"
	notes: "[
		Usage pattern:
		
			across String_8_scope as scope loop
				if attached scope.item as str then
					...
				end
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:53:33 GMT (Tuesday 20th August 2024)"
	revision: "3"

deferred class
	EL_SHARED_STRING_8_BUFFER_SCOPES

inherit
	EL_ANY_SHARED

	EL_SHARED_STRING_POOLS

feature {NONE} -- Constants

	String_8_scope: EL_BORROWED_STRING_SCOPE [STRING_8, EL_BORROWED_STRING_8_CURSOR]
		-- defines across loop scope in which a single `STRING_8' buffer can be borrowed
		-- and automatically reclaimed on loop exit
		once
			create Result.make (Shared_string_8_pool)
		end

	String_8_pool_scope: EL_STRING_POOL_SCOPE [STRING_8]
		-- defines across loop scope in which multiple `STRING_8' buffers can be borrowed
		-- and automatically reclaimed on loop exit
		once
			create Result.make (Shared_string_8_pool)
		end

end