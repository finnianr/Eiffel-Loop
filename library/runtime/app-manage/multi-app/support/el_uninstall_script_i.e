note
	description: "Creates script to uninstall application and a sub-script to remove user files"
	notes: "[
		
		**Windows Example**

			@echo off
			title Uninstall My Ching
			start /WAIT /D "C:\Program Files\Hex 11 Software\My Ching\bin" myching.exe -uninstall -silent
			if %ERRORLEVEL% neq 0 goto Cancelled
			call "C:\Program Files\Uninstall\remove_My_Ching_user_files.bat"
			del "C:\Program Files\Uninstall\remove_My_Ching_user_files.bat"
			echo "My Ching" removed.
			pause
			del "C:\Program Files\Uninstall\uninstall-My Ching.bat"
			:Cancelled
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-11 15:39:58 GMT (Friday 11th August 2023)"
	revision: "23"

deferred class
	EL_UNINSTALL_SCRIPT_I

inherit
	EVOLICITY_SERIALIZEABLE

	EL_MODULE_CONSOLE; EL_MODULE_DIRECTORY; EL_MODULE_EXECUTABLE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_SYSTEM

	EL_SHARED_APPLICATION_LIST; EL_SHARED_PHRASE; EL_SHARED_UNINSTALL_TEXTS

	EL_SHARED_INSTALL_UNINSTALL_TESTER; EL_CHARACTER_CONSTANTS

feature {NONE} -- Initialization

	make (a_uninstall_app: like uninstall_app)
		require
			has_main: Application_list.has_main
		do
			uninstall_app := a_uninstall_app
			Console.show_all (Lio_visible_types)
			-- For Linux this is: /opt/Uninstall
			-- For Windows: C:\Program Files\Uninstall

			output_path := Test_aware.absolute_path (Directory.Applications, relative_output_path)

			make_from_file (output_path)
			set_encoding_from_other (script_encoding)
		end

feature -- Basic operations

	create_remove_directories_script
		-- create script to remove application data and configuration directories for all users
		do
			if attached remove_files_script_path as script_path then
				File_system.make_directory (script_path.parent)
				if attached new_script (script_path) as script then
					script.open_write
					write_remove_directory_lines (script)
					script.close
				end
			end
		end

feature {NONE} -- Deferred		

	dot_extension: STRING
		deferred
		end

	lio_visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		deferred
		end

	remove_dir_and_parent_commands: ZSTRING
		-- command lines to remove directory and parent if empty
		deferred
		end

	script_encoding: EL_ENCODEABLE_AS_TEXT
		deferred
		end

feature {NONE} -- Implementation

	remove_files_script_path: FILE_PATH
		do
			Result := output_path.parent + Remove_user_files_template #$ [menu_name, dot_extension]
			Result.base.translate (Space #* 1, Underscore #* 1)
		end

	menu_name: ZSTRING
		do
			if attached Application_list.main as main then
				Result := main.desktop.menu_name
			else
				create Result.make_empty
			end
		end

	new_script (path: FILE_PATH): EL_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (path)
			Result.set_encoding_from_other (script_encoding)
		end

	relative_output_path: FILE_PATH
		do
			Result := "Uninstall/uninstall-"
			Result.base.append (menu_name)
			Result.add_extension (dot_extension)
		end

	write_remove_directory_lines (script: like new_script)
		do
			across System.user_permutation_list (Directory.app_all_list) as list loop
				write_remove_directory (script, list.item)
			end
			write_remove_directory (script, Directory.Application_installation)
		end

	write_remove_directory (script: like new_script; dir_path: DIR_PATH)
		do
			script.put_string (remove_dir_and_parent_commands #$ [dir_path.escaped, dir_path.parent.escaped])
			script.put_new_line
		end

	uninstall_command: EL_ZSTRING_LIST
		do
			create Result.make_from_array (<< Application_path.escaped, uninstall_option >>)
			if attached uninstall_app.Desktop.command_line_options as options and then options.count > 0 then
				Result.extend (options)
			end
		end

	uninstall_option: ZSTRING
		do
			Result := Hyphen.as_zstring (1) + uninstall_app.Option_name
		end

feature {NONE} -- Internal attributes

	uninstall_app: EL_STANDARD_UNINSTALL_APP

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["completion_message",			agent: ZSTRING do Result := Text.app_removed_template #$ [menu_name] end],
				["description",					agent: ZSTRING do Result := Text.removing_program_files end],
				["encoding_name",					agent: STRING do Result := script_encoding.encoding_name end],
				["script_path",					agent: ZSTRING do Result := output_path.escaped end],
				["title",							agent: ZSTRING do Result := uninstall_app.Name end],
				["remove_files_script_path",	agent: ZSTRING do Result := remove_files_script_path.escaped end],
				["return_prompt",					agent: ZSTRING do Result := Phrase.hit_return_to_finish.as_upper end],
				["uninstall_command",			agent: ZSTRING do Result := uninstall_command.joined_words end]
			>>)
		end

feature {NONE} -- Constants

	Application_path: FILE_PATH
		once
			Result := Directory.Application_bin + Executable.name
		end

	Remove_user_files_template: ZSTRING
		once
			Result := "remove_%S_user_files.%S"
		end

end