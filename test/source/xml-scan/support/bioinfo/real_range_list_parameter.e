note
	description: "Real range list parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-07 14:00:57 GMT (Friday 7th March 2025)"
	revision: "9"

class
	REAL_RANGE_LIST_PARAMETER

inherit
	RANGE_LIST_PARAMETER [REAL]

create
	make

feature {NONE} -- Implementation

	numeric_string (v: REAL): STRING
		do
			Result := v.out
		end

	to_numeric (string: ZSTRING): REAL
		do
			Result := string.to_real
		end

end