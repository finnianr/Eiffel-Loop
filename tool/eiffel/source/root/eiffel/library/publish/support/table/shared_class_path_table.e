note
	description: "Shared instance of [$source CLASS_HTML_PATH_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-03 12:21:07 GMT (Wednesday 3rd March 2021)"
	revision: "8"

deferred class
	SHARED_CLASS_PATH_TABLE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Class_path_table: CLASS_HTML_PATH_TABLE
		once ("PROCESS")
			create Result.make
		end
end