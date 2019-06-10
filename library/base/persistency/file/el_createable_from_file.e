note
	description: "Object that is createable from a file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 17:13:16 GMT (Monday 10th June 2019)"
	revision: "3"

deferred class
	EL_CREATEABLE_FROM_FILE

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH)
		require
			path_exists: a_file_path.exists
		deferred
		end
end
