note
	description: "[
		Abstract interface to data object that can be stored to file `file_path' with or without integrity
		checks on restoration. See `store' versus `safe_store'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 11:23:03 GMT (Monday 5th December 2022)"
	revision: "11"

deferred class
	EL_FILE_PERSISTENT

inherit
	EL_FILE_PERSISTENT_I

feature {NONE} -- Initialization

	make_from_file (a_file_path: like file_path)
			--
		do
			file_path := a_file_path
		end

feature -- Access

	file_path: FILE_PATH

feature -- Element change

	set_file_path (a_file_path: FILE_PATH)
			--
		do
			file_path := a_file_path
		end

end