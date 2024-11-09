note
	description: "Routine to select string pool conforming to ${EL_STRING_BUFFER_POOL} by string type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 8:59:44 GMT (Friday 8th November 2024)"
	revision: "5"

deferred class
	EL_STRING_POOL_ROUTINES

inherit
	EL_STRING_HANDLER

	EL_SHARED_STRING_8_BUFFER_POOL

	EL_SHARED_STRING_32_BUFFER_POOL

	EL_SHARED_ZSTRING_BUFFER_POOL
		rename
			String_pool as ZString_pool
		end

feature {NONE} -- Implementation

	string_pool (str: READABLE_STRING_GENERAL): like STRING_BUFFER_POOL
		-- selected string pool conforming to ${EL_STRING_BUFFER_POOL} by `str' type
		do
			inspect string_storage_type (str)
				when '1' then
					Result := String_8_pool
				when '4' then
					Result := String_32_pool
				when 'X' then
					Result := ZString_pool
			end
		end

feature {NONE} -- Type definitions

	STRING_BUFFER_POOL: EL_STRING_BUFFER_POOL [EL_STRING_BUFFER [STRING_GENERAL, READABLE_STRING_GENERAL]]
		require
			never_called: False
		once

		end

end