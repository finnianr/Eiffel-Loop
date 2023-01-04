note
	description: "Shared instance of [$source EL_ESCAPE_TABLES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 11:33:19 GMT (Wednesday 4th January 2023)"
	revision: "1"

deferred class
	EL_SHARED_ESCAPE_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Escape_table: EL_ESCAPE_TABLES
		once
			create Result
		end

end