note
	description: "Alpha-numeric code that fits into 8 bytes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-15 13:43:04 GMT (Friday 15th October 2021)"
	revision: "2"

class
	EL_CODE_64_REF

inherit
	EL_ALPHA_NUMERIC_CODE

	NATURAL_64_REF
		rename
			set_item as set_from_code
		undefine
			out
		redefine
			to_reference
		end

feature -- Conversion

	to_reference: EL_CODE_64_REF
			-- Associated reference of Current
		do
			create Result
			Result.set_from_code (item)
		end

feature {NONE} -- Constants

	Byte_count: INTEGER = 8
end