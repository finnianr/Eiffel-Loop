note
	description: "Creates script to uninstall application and a sub-script to remove user files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 17:58:14 GMT (Sunday 24th November 2019)"
	revision: "8"

deferred class
	EL_UNINSTALL_SCRIPT_I

inherit
	EVOLICITY_SERIALIZEABLE

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_CONSOLE

	EL_MODULE_COMMAND

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DEFERRED_LOCALE

	EL_INSTALLER_DEBUG

	EL_SHARED_APPLICATION_LIST

feature {NONE} -- Initialization

	make
		require
			has_main: Application_list.has_main
			has_uninstall: Application_list.has_uninstaller
		local
			l_template: ZSTRING
		do
			Console.show_all (Lio_visible_types)
			-- For Linux this is: /opt/Uninstall
			output_path := Directory.Applications + ("Uninstall/uninstall-" + menu_name)
			if_installer_debug_enabled (output_path)
			output_path.add_extension (dot_extension)
			make_from_file (output_path)
			create script.make_with_name (output_path)

			l_template := "remove_%S_user_files." + dot_extension
			remove_files_script_path := output_path.parent + l_template #$ [menu_name]
			remove_files_script_path.base.translate_general (" ", "_")
		end

feature -- Access

	remove_files_script_path: EL_FILE_PATH

feature -- Basic operations

	write_remove_directories_script
			-- create script to remove application data and configuration directories for all users
		do
			File_system.make_directory (remove_files_script_path.parent)
			script.make_open_write (remove_files_script_path)

			command.new_user_info.do_for_existing_directories (agent write_remove_directory)
			write_remove_directory (Directory.Application_installation)
			script.close
		end

feature {NONE} -- Implementation

	completion_message: ZSTRING
		local
			l_template: ZSTRING
		do
			Locale.set_next_translation ("%"%S%" removed.")
			l_template := Locale * "{APP_NAME-removed}"
			Result := l_template #$ [menu_name]
		end

	description: ZSTRING
		do
			Result := Locale * "Removing program files"
		end

	dot_extension: STRING
		deferred
		end

	escaped (path: EL_PATH): ZSTRING
		do
			Result := path.escaped
		end

	lio_visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		deferred
		end

	menu_name: ZSTRING
		do
			Result := Application_list.main.desktop.menu_name
		end

	write_remove_directory (dir_path: EL_DIR_PATH)
		do
			script.put_string (remove_dir_and_parent_commands #$ [dir_path.escaped, dir_path.parent.escaped])
			script.put_new_line
		end

	remove_dir_and_parent_commands: ZSTRING
		-- command lines to remove directory and parent if empty
		deferred
		end

feature {NONE} -- Internal attributes

	script: EL_PLAIN_TEXT_FILE

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["application_path",				 agent escaped (application_path)],
				["script_path",					 agent: ZSTRING do Result := output_path.escaped end],
				["remove_files_script_path",	 agent: ZSTRING do Result := remove_files_script_path.escaped end],

				["completion_message",			 agent completion_message],
				["description",					 agent description],
				["title",							 agent: ZSTRING do Result := Application_list.uninstaller.Name end],
				["return_prompt",					 agent: ZSTRING do Result := return_prompt end]
			>>)
		end

feature {NONE} -- Constants

	Application_path: EL_FILE_PATH
		once
			Result := Directory.Application_bin + Execution_environment.Executable_name
		end

	Return_prompt: ZSTRING
		once
			Result := Locale * "RETURN TO FINISH"
		end

end
