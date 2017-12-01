note
	description: "[
		Creates a file context menu entry for application in the OS file manager.
		In Unix with the GNOME desktop this is implemented using Nautilus-scripts.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-30 20:09:49 GMT (Thursday 30th November 2017)"
	revision: "3"

deferred class
	EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_I

inherit
	EL_APPLICATION_INSTALLER_I
		rename
			command_args_template as launch_script_template,
			command_args as script_args
		redefine
			getter_function_table
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (a_menu_path: like menu_path)
			--
		do
			make_default
			menu_path := a_menu_path; menu_name := menu_path.base
		end

feature -- Basic operations

	install
			--
		do
			set_launch_script_path

			File_system.make_directory (launch_script_path.parent)
			lio.put_line (launch_script_path.to_string)
			write_script (launch_script_path)
			script_file.add_permission ("uog", "x")
		end

	uninstall
			--
		local
			l_script_file: PLAIN_TEXT_FILE
		do
			set_launch_script_path
			l_script_file := script_file
			if l_script_file.exists then
				l_script_file.delete
			end
			File_system.delete_empty_branch (launch_script_path.parent)
		end

feature -- Access

	launch_script_location: EL_DIR_PATH
			--
		deferred
		end

	launch_script_path: EL_FILE_PATH

	menu_path: EL_FILE_PATH

	script_file: PLAIN_TEXT_FILE
			--
		do
			create Result.make_with_name (launch_script_path)
		end

feature {NONE} -- Implementation

	set_launch_script_path
			--
		do
			launch_script_path := Directory.home.joined_dir_path (launch_script_location) + menu_path
		end

feature {NONE} -- Evolicity implementation

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
			 	["has_path_argument", 		 agent: BOOLEAN_REF do Result := (not input_path_option_name.is_empty).to_reference end],
				["input_path_option_name",	 agent: STRING do Result := input_path_option_name end]
			>>)
		end

end
