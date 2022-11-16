note
	description: "Encoding constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_ENCODING_CONSTANTS

inherit
	EL_ANY_SHARED

feature -- Encoding classes

	Latin: NATURAL = 0x1000

	Other: NATURAL = 0x4000

	Utf: NATURAL = 0x3000

	Windows: NATURAL = 0x2000

feature -- Common encodings

	Latin_1: NATURAL = 0x1001

	Utf_8: NATURAL = 0x3008

	Utf_16: NATURAL = 0x3010

feature -- Bit masks

	ID_mask: NATURAL = 0xFFF
		-- mask out encoding class leaving only id

	Class_mask: NATURAL = 0xF000
		-- mask out encoding id leaving only class

end