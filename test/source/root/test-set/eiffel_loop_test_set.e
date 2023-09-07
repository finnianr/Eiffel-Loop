note
	description: "Test set using files in $EIFFEL_LOOP/test/data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 7:27:22 GMT (Thursday 7th September 2023)"
	revision: "18"

deferred class
	EIFFEL_LOOP_TEST_SET

inherit
	EL_DIRECTORY_CONTEXT_TEST_SET

	SHARED_DEV_ENVIRON

feature {NONE} -- Implementation

	working_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir
		end

end