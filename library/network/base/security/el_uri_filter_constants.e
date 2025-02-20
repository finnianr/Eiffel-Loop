note
	description: "Constants related to ${EL_URI_FILTER_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-20 10:58:19 GMT (Thursday 20th February 2025)"
	revision: "2"

deferred class
	EL_URI_FILTER_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Constants

	File_match_text: ZSTRING
		once
			Result := "match-%S.txt"
		end

	Predicate: TUPLE [has_extension, first_step, starts_with, ends_with: STRING]
		once
			create Result
			Tuple.fill (Result, "has_extension, first_step, starts_with, ends_with")
		end

end