note
	description: "Constants for Eiffel grep searches"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-07 16:37:52 GMT (Saturday 7th January 2023)"
	revision: "1"

deferred class
	GREP_RESULT_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Class_keyword: ZSTRING
		once
			Result := "class"
		end

	Comment: TUPLE [directory, matching_lines: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "-- DIRECTORY:, -- matching lines")
		end

end