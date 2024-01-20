note
	description: "4 byte implementation of ${EL_CODE_REPRESENTATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_CODE_32_REPRESENTATION

inherit
	EL_CODE_REPRESENTATION [NATURAL_32]

create
	make

feature -- Basic operations

	append_to_string (n: NATURAL_32; str: ZSTRING)
		do
			str.append_natural_32 (n)
		end

feature -- Measurement

	byte_count: INTEGER
		do
			Result := {PLATFORM}.Natural_32_bytes
		end

feature -- Conversion

	to_value (general: READABLE_STRING_GENERAL): NATURAL_32
		do
			if attached Buffer_8.to_same (general) as str then
				($Result).memory_copy (str.area.base_address, byte_count.min (str.count))
			end
		end

feature {NONE} -- Implementation

	memory_copy (area: SPECIAL [CHARACTER]; a_value: NATURAL_32)
		do
			area.base_address.memory_copy ($a_value, byte_count)
		end
end