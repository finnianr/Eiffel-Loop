note
	description: "Byte order swap routines for endian conversions"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 15:13:35 GMT (Sunday 5th November 2023)"
	revision: "3"

deferred class
	EL_BYTE_SWAP_ROUTINES_I

inherit
	EL_OS_DEPENDENT

feature {NONE} -- Implementation

	reversed_16 (v: NATURAL_16): NATURAL_16
		deferred
		end

	reversed_32 (v: NATURAL_32): NATURAL_32
		deferred
		end

	reversed_64 (v: NATURAL_64): NATURAL_64
		deferred
		end

end