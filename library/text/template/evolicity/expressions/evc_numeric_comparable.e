note
	description: "Evolicity comparable item conforming to ${NUMERIC}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 12:33:15 GMT (Tuesday 18th March 2025)"
	revision: "1"

deferred class
	EVC_NUMERIC_COMPARABLE [N -> NUMERIC]

inherit
	EVC_COMPARABLE

	EL_MODULE_CONVERT_STRING

feature {NONE} -- Initialization

	make (number: IMMUTABLE_STRING_8)
			--
		require
			valid_number: Convert_string.is_convertible (number, {N})
		do
			item := new_reference (number)
		end

feature {NONE} -- Implementation

	new_reference (number: IMMUTABLE_STRING_8): COMPARABLE
		deferred
		end
end