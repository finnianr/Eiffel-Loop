note
	description: "Test ${COMPRESS_MANIFEST_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-22 8:39:57 GMT (Thursday 22nd August 2024)"
	revision: "1"

class
	COMPRESS_MANIFEST_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["code_highlighting", agent test_code_highlighting]
			>>)
		end

feature -- Tests

	test_code_highlighting
		note
			testing: "[
				covers/{COMPRESS_MANIFEST_COMMAND}.execute
			]"
		local
			cmd: COMPRESS_MANIFEST_COMMAND
		do
			if attached file_list.first_path as manifest_path then
				create cmd.make (manifest_path, create {FILE_PATH})
				cmd.execute
				assert_same_digest (Plain_text, cmd.output_path, "UdIiAMd5aIi6MvStSKWfoA==")
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "error-codes.txt" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := Dev_environ.EL_test_data_dir #+ "code/C/windows"
		end

end