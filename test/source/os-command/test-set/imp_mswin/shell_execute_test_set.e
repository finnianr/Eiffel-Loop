note
	description: "Test class [$source EL_SHELL_EXECUTE_INFO_CPP_API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-02 19:19:02 GMT (Tuesday 2nd January 2024)"
	revision: "1"

class
	SHELL_EXECUTE_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["admin_level_execution", agent test_admin_level_execution]
			>>)
		end

feature -- Tests

	test_admin_level_execution
		-- SHELL_EXECUTE_TEST_SET.test_admin_level_execution
		note
			testing: "[
				covers/{EL_WINDOWS_ADMIN_SHELL_COMMAND}.execute,
				covers/{EL_WINDOWS_ADMIN_SHELL_COMMAND}.set_command_and_parameters
			]"
		local
			command: EL_OS_COMMAND_I; destination_path: FILE_PATH
		do
			create {EL_COPY_FILE_COMMAND_IMP} command.make ("data/txt/file.txt", Directory.applications)
			command.administrator.enable
			command.execute
			assert ("successful", not command.has_error)
			destination_path := Directory.applications + "file.txt"
			if destination_path.exists then
				create {EL_DELETE_FILE_COMMAND_IMP} command.make (destination_path)
				command.administrator.enable
				command.execute
				assert ("File deleted", not destination_path.exists)
			else
				failed ("File exists")
			end
		end

end