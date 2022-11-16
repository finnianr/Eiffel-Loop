note
	description: "Object that is createable from a file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_CREATEABLE_FROM_FILE

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
		deferred
		end
end