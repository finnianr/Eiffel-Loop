note
	description: "Unix implementation of [$source EL_BYTE_SWAP_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

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