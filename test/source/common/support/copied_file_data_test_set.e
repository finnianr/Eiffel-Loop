note
	description: "Test set using file data relative to Eiffel-Loop home directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:11:37 GMT (Monday 5th May 2025)"
	revision: "2"

deferred class
	COPIED_FILE_DATA_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as eiffel_loop_dir
		end

	SHARED_DATA_DIRECTORIES; SHARED_EIFFEL_LOOP
end