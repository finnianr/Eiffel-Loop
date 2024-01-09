note
	description: "Unix implementation of [$source EL_BYTE_SWAP_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:00:16 GMT (Sunday 7th January 2024)"
	revision: "4"

class
	EL_BYTE_SWAP_ROUTINES_IMP

inherit
	EL_BYTE_SWAP_ROUTINES_I
	
	EL_UNIX_IMPLEMENTATION

	EL_GNU_C_API
		rename
			c_byte_swap_16 as reversed_16,
			c_byte_swap_32 as reversed_32,
			c_byte_swap_64 as reversed_64
		end

end