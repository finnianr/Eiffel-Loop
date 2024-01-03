note
	description: "[
		Interface to
		[https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecutea ShellExecute]
		function from the Windows Shell API `<Shellapi.h>'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-03 16:41:33 GMT (Wednesday 3rd January 2024)"
	revision: "2"

class
	EL_WINDOWS_SHELL_COMMAND

inherit
	EL_COMMAND

	EL_SHELL_EXECUTE_C_API

	EL_OS_DEPENDENT

	EL_EXTERNAL_LIBRARY [COM_INITIALIZER]

	EL_WINDOWS_IMPLEMENTATION

	EL_MODULE_TUPLE

	EL_SHARED_NATIVE_STRING

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize_library
			command_name_arg := Empty_argument
			directory_arg := Empty_argument
			parameters_arg := Empty_argument
			operation_arg := Empty_argument
			show_type := c_show_normal
		end

feature -- Basic operations

	execute
		local
			n: INTEGER
		do
			n := c_shell_execute (
				default_pointer,
				pointer (operation_arg), pointer (command_name_arg), pointer (parameters_arg),
				pointer (directory_arg), show_type
			)
			is_successful := n > 32
		end

feature -- Element change

	set_command_and_parameters (string: READABLE_STRING_GENERAL)
		local
			space_index: INTEGER
		do
			space_index := string.index_of (' ', 1)
			if space_index > 0 then
				command_name_arg := Native_string.new_substring_data (string, 1, space_index - 1)
				parameters_arg := Native_string.new_substring_data (string, space_index + 1, string.count)
			else
				set_command_name (string)
			end
		end

	set_command_name (a_name: READABLE_STRING_GENERAL)
		do
			command_name_arg := Native_string.new_data (a_name)
		end

	set_directory (a_directory: READABLE_STRING_GENERAL)
		do
			directory_arg := Native_string.new_data (a_directory)
		end

	set_parameters (a_parameters: READABLE_STRING_GENERAL)
		do
			parameters_arg := Native_string.new_data (a_parameters)
		end

	set_operation (a_operation: IMMUTABLE_STRING_8)
		require
			valid_operation: Valid_operations.has (a_operation)
		do
			operation_arg := Native_string.new_data (a_operation)
		end

feature -- Status change

	enable_administrator
		-- Launches an application as Administrator. User Account Control (UAC) will prompt the user for
		-- consent to run the application elevated or enter the credentials of an administrator account
		-- used to run the application.
		do
			set_operation (Operation.runas)
		end

	enable_hide
		do
			show_type := c_hide
		end

	enable_show_normal
		do
			show_type := c_show_normal
		end

feature -- Status query

	is_successful: BOOLEAN
		-- last call to `execute' was successful

feature -- Constants

	Operation: TUPLE [edit, explore, find, open, print_, runas: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "edit, explore, find, open, print, runas")
		end

	Valid_operations: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		once
			create Result.make_from_tuple (Operation)
			Result.compare_objects
		end

feature {NONE} -- Implementation

	pointer (arg: MANAGED_POINTER): POINTER
		-- Null pointer if `arg.count = 0'
		do
			if arg.count > 0 then
				Result := arg.item
			end
		end

feature {NONE} -- Internal attributes

	command_name_arg: MANAGED_POINTER
		-- argument LPCTSTR lpFile

	directory_arg: MANAGED_POINTER
		-- argument LPCTSTR lpDirectory

	operation_arg: MANAGED_POINTER
		-- argument LPCTSTR lpOperation

	parameters_arg: MANAGED_POINTER
		-- argument LPCTSTR lpParameters

	show_type: INTEGER
		-- argument INT nShowCmd

feature {NONE} -- Constants

	Empty_argument: MANAGED_POINTER
		once
			create Result.make (0)
		end

end