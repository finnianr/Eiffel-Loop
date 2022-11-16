note
	description: "Shared instance of [$source CLASS_HTML_PATH_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "9"

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