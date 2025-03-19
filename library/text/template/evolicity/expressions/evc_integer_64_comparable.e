note
	description: "Evolicity integer 64 comparable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 12:40:39 GMT (Tuesday 18th March 2025)"
	revision: "6"

class
	EVC_INTEGER_64_COMPARABLE

inherit
	EVC_NUMERIC_COMPARABLE [INTEGER_64]

create
	make

feature {NONE} -- Implementation

	new_reference (number: IMMUTABLE_STRING_8): INTEGER_64_REF
			--
		do
			Result := Convert_string.to_integer_64 (number).to_reference
		end

end