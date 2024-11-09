note
	description: "[
		Shared instances of reusable string buffers for type ${STRING_32} accessible
		via **across** loop scope.
	]"
	notes: "[
		Usage pattern:
		
			across String_32_scope as scope loop
				if scope buffer.item as str then
					...
				end
			end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 9:03:00 GMT (Friday 8th November 2024)"
	revision: "4"

deferred class
	EL_SHARED_STRING_32_BUFFER_SCOPES

obsolete
	"Use EL_SHARED_STRING_32_BUFFER_POOL"

inherit
	EL_ANY_SHARED

	EL_SHARED_STRING_POOLS

feature {NONE} -- Constants

	String_32_scope: EL_BORROWED_STRING_SCOPE [STRING_32, EL_BORROWED_STRING_32_CURSOR]
		-- defines across loop scope in which a single `STRING_32' buffer can be borrowed
		-- and automatically reclaimed on loop exit
		once
			create Result.make (Shared_string_32_pool)
		end

	String_32_pool_scope: EL_STRING_POOL_SCOPE [STRING_32]
		-- defines across loop scope in which multiple `STRING_32' buffers can be borrowed
		-- and automatically reclaimed on loop exit
		once
			create Result.make (Shared_string_32_pool)
		end

end