note
	description: "Shared instance of [$source EL_NATIVE_STRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-03 15:24:14 GMT (Wednesday 3rd January 2024)"
	revision: "2"

deferred class
	EL_SHARED_NATIVE_STRING

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Native_string: EL_NATIVE_STRING
		once
			create Result.make_empty (0)
		end

end