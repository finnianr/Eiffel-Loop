note
	description: "Miscellaneous functions from [https://www.gnu.org/software/libc/ GNU C library]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:15:23 GMT (Sunday 7th January 2024)"
	revision: "2"

deferred class
	EL_GNU_C_API

inherit
	EL_C_API

feature {NONE} -- Byte swaping

	c_byte_swap_16 (v: NATURAL_16): NATURAL_16
		external
			"C [macro <byteswap.h>]"
		alias
			"bswap_16"
		end

	c_byte_swap_32 (v: NATURAL_32): NATURAL_32
		external
			"C [macro <byteswap.h>]"
		alias
			"bswap_32"
		end

	c_byte_swap_64 (v: NATURAL_64): NATURAL_64
		external
			"C [macro <byteswap.h>]"
		alias
			"bswap_64"
		end


end