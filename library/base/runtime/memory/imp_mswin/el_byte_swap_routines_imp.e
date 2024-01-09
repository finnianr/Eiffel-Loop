note
	description: "Windows implementation of [$source EL_BYTE_SWAP_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 9:51:57 GMT (Sunday 7th January 2024)"
	revision: "4"

class
	EL_BYTE_SWAP_ROUTINES_IMP

inherit
	EL_BYTE_SWAP_ROUTINES_I
	
	EL_WINDOWS_IMPLEMENTATION

	EL_WIN_32_C_API
		rename
			c_byte_swap_unsigned_short as reversed_16,
			c_byte_swap_unsigned_long as reversed_32,
			c_byte_swap_unsigned_int64 as reversed_64
		end

end