note
	description: "Test ${COMPRESS_MANIFEST_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-08 13:09:33 GMT (Saturday 8th March 2025)"
	revision: "3"

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
				assert_same_digest (Plain_text, cmd.output_path, "iaDlon6htXz8H37wVLLt8A==")
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