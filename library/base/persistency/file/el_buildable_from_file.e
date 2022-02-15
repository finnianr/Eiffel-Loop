note
	description: "Object that is buildable from a file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 14:11:32 GMT (Tuesday 15th February 2022)"
	revision: "5"

deferred class
	EL_BUILDABLE_FROM_FILE

feature -- Element change

	build_from_file (a_file_path: FILE_PATH)
		require
			path_exists: a_file_path.exists
		deferred
		end
end