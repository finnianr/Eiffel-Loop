note
	description: "[
		Creates a file context menu entry for application in the OS file manager.
		In Unix with the GNOME desktop this is implemented using Nautilus-scripts.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-19 12:35:38 GMT (Tuesday 19th June 2018)"
	revision: "6"

deferred class
	EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I

inherit
	EL_DESKTOP_ENVIRONMENT_I
		rename
			make as make_installer,
			command_args_template as launch_script_template,
			command_args as script_args
		redefine
			getter_function_table, make_default
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_SUB_APPLICATION; a_menu_path: READABLE_STRING_GENERAL)
			--
		do
			make_installer (installable)
			create menu_path.make_from_general (a_menu_path)
			menu_name := menu_path.base
			input_path_option_name := installable.input_path_option_name
		end

	make_default
		do
			Precursor
			input_path_option_name := Empty_string_8
		end

feature -- Basic operations

	install
			--
		do
			set_launch_script_path

			File_system.make_directory (launch_script_path.parent)
			lio.put_line (launch_script_path.to_string)
			write_script (launch_script_path)
			File_system.add_permission (launch_script_path, "uog", "x")
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

feature {NONE} -- Internal attributes

	input_path_option_name: STRING

feature {NONE} -- Evolicity implementation

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
			 	["has_path_argument", 		 agent: BOOLEAN_REF do Result := (not input_path_option_name.is_empty).to_reference end] +
				["input_path_option_name",	 agent: STRING do Result := input_path_option_name end]
		end

end
