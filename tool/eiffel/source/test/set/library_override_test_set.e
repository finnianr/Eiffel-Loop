note
	description: "Test ${OVERRIDE_FEATURE_EDITOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 17:59:03 GMT (Wednesday 7th May 2025)"
	revision: "1"

class
	LIBRARY_OVERRIDE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["sd_shared", agent test_sd_shared]
			>>)
		end

feature -- Tests

	test_sd_shared
		-- LIBRARY_OVERRIDE_TEST_SET.sd_shared
		local
			editor: SD_SHARED_CLASS
		do
			create editor.make
			editor.set_output_path (Work_area_dir + editor.relative_source_path)
			editor.execute
		end

end