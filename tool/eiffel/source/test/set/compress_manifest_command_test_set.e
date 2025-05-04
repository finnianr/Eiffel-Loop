note
	description: "Test ${COMPRESS_MANIFEST_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:30:48 GMT (Sunday 4th May 2025)"
	revision: "4"

class
	COMPRESS_MANIFEST_COMMAND_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Windows_code_dir
		end

	SHARED_DATA_DIRECTORIES

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
			create Result.make_from_array (<< Windows_code_dir + "error-codes.txt" >>)
		end

feature {NONE} -- Constants

	Windows_code_dir: DIR_PATH
		once
			Result := Data_dir.code #+ "C/windows"
		end

end