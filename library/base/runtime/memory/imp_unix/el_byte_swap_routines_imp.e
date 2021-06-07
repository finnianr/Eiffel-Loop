note
	description: "Unix implementation of [$source EL_BYTE_SWAP_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-07 17:06:05 GMT (Monday 7th June 2021)"
	revision: "1"

class
	EL_BYTE_SWAP_ROUTINES_IMP

inherit
	EL_BYTE_SWAP_ROUTINES_I
	
	EL_OS_IMPLEMENTATION

feature {NONE} -- Implementation

	reversed_16 (v: NATURAL_16): NATURAL_16
		external
			"C [macro <byteswap.h>]"
		alias
			"bswap_16"
		end

	reversed_32 (v: NATURAL_32): NATURAL_32
		external
			"C [macro <byteswap.h>]"
		alias
			"bswap_32"
		end

	reversed_64 (v: NATURAL_64): NATURAL_64
		external
			"C [macro <byteswap.h>]"
		alias
			"bswap_64"
		end

end