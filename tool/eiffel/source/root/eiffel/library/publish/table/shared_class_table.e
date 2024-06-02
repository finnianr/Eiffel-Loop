note
	description: "Shared instance of ${CLASS_HTML_PATH_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-01 9:19:19 GMT (Saturday 1st June 2024)"
	revision: "11"

deferred class
	SHARED_CLASS_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Class_table: EIFFEL_CLASS_TABLE
		once ("PROCESS")
			create Result.make
		end
end