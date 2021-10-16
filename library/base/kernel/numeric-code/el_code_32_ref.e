note
	description: "Alpha-numeric code that fits into 4 bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-15 13:42:37 GMT (Friday 15th October 2021)"
	revision: "2"

class
	EL_CODE_32_REF

inherit
	EL_ALPHA_NUMERIC_CODE

	NATURAL_32_REF
		undefine
			out
		redefine
			to_reference
		end

feature -- Conversion

	to_reference: EL_CODE_32_REF
			-- Associated reference of Current
		do
			create Result
			Result.set_item (item)
		end

feature {NONE} -- Implementation

	set_from_code (code_64: NATURAL_64)
		do
			set_item (code_64.as_natural_32)
		end

feature {NONE} -- Constants

	Byte_count: INTEGER = 4
end