note
	description: "[
		Launches an application as Administrator. User Account Control (UAC) will prompt the user
		for consent to run the application elevated or enter the credentials of an administrator
		account used to run the application.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-02 19:27:26 GMT (Tuesday 2nd January 2024)"
	revision: "1"

class
	EL_WINDOWS_ADMIN_SHELL_COMMAND

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			make_default as make
		redefine
			make
		end

	EL_COMMAND
		undefine
			copy, is_equal
		end

	EL_SHELL_EXECUTE_INFO_C_API
		rename
			c_size_of_SHELLEXECUTEINFOW as c_size_of
		undefine
			copy, is_equal
		end

	EL_OS_DEPENDENT
		undefine
			copy, is_equal
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_SHARED_NATIVE_STRING

create
	make

feature {NONE} -- Initialization

	make
		local
			null: POINTER
		do
			Precursor
			c_set_size (self_ptr, c_size_of)
			c_set_verb (self_ptr, Run_as_admin.item)
			c_set_file (self_ptr, null)
			c_set_directory (self_ptr, null)
			c_set_n_show (self_ptr, Hide)

			command_name_data := Empty_data
			directory_data := Empty_data
			parameters_data := Empty_data
		end

feature -- Basic operations

	execute
		do
			is_successful := c_shell_execute (self_ptr)
		end

feature -- Element change

	set_command_and_parameters (string: READABLE_STRING_GENERAL)
		local
			space_index: INTEGER
		do
			space_index := string.index_of (' ', 1)
			if space_index > 0 then
				Native_string.set_substring (string, 1, space_index - 1)
				command_name_data := Native_string.trimmed_data
				c_set_file (self_ptr, command_name_data.item)

				Native_string.set_substring (string, space_index + 1, string.count)
				parameters_data := Native_string.trimmed_data
				c_set_parameters (self_ptr, parameters_data.item)
			else
				set_command_name (string)
			end
		end

	set_command_name (a_name: READABLE_STRING_GENERAL)
		do
			Native_string.set_string (a_name)
			command_name_data := Native_string.trimmed_data
			c_set_file (self_ptr, command_name_data.item)
		end

	set_directory (a_directory: READABLE_STRING_GENERAL)
		do
			Native_string.set_string (a_directory)
			directory_data := Native_string.trimmed_data
			c_set_directory (self_ptr, directory_data.item)
		end

	set_parameters (a_parameters: READABLE_STRING_GENERAL)
		do
			Native_string.set_string (a_parameters)
			parameters_data := Native_string.trimmed_data
			c_set_parameters (self_ptr, parameters_data.item)
		end

	set_show_type (type: INTEGER)
		require
		do

		end

feature -- Status query

	is_successful: BOOLEAN
		-- last call to `execute' was successful

feature {NONE} -- Internal attributes

	command_name_data: MANAGED_POINTER

	directory_data: MANAGED_POINTER

	parameters_data: MANAGED_POINTER

feature -- Show Constants

	Hide: INTEGER
		-- Hides the window and activates another window.
		once
			Result := c_hide
		end

	Show_normal: INTEGER
		-- If the window is minimized or maximized, `SW_SHOWNORMAL' restores it to its original size and position.
		once
			Result := c_show_normal
		end

feature {NONE} -- Constants

	Empty_data: MANAGED_POINTER
		once
			create Result.make (0)
		end

	Run_as_admin: MANAGED_POINTER
		once
			Native_string.set_string ("runas")
			Result := Native_string.trimmed_data
		end

end