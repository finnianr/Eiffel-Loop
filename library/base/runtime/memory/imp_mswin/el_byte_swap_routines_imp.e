note
	description: "Windows implementation of [$source EL_BYTE_SWAP_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:15:26 GMT (Sunday 5th November 2023)"
	revision: "3"

class
	EL_BYTE_SWAP_ROUTINES_IMP

inherit
	EL_BYTE_SWAP_ROUTINES_I
	
	EL_WINDOWS_IMPLEMENTATION

feature {NONE} -- Implementation

	reversed_16 (v: NATURAL_16): NATURAL_16
		-- unsigned short _byteswap_ushort ( unsigned short val );
		external
			"C (unsigned short): EIF_NATURAL_16 | <stdlib.h>"
		alias
			"_byteswap_ushort"
		end

	reversed_32 (v: NATURAL_32): NATURAL_32
		-- unsigned long _byteswap_ulong ( unsigned long val );
		external
			"C (unsigned long): EIF_NATURAL_32 | <stdlib.h>"
		alias
			"_byteswap_ulong"
		end

	reversed_64 (v: NATURAL_64): NATURAL_64
		-- unsigned __int64 _byteswap_uint64 ( unsigned __int64 val );
		external
			"C (unsigned __int64): EIF_NATURAL_64 | <stdlib.h>"
		alias
			"_byteswap_uint64"
		end

end