note
	description: "[
		Delayed removal of program directory on uninstall to avoid permission problem
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-25 13:39:50 GMT (Monday 25th April 2016)"
	revision: "7"

deferred class
	EL_INSTALLED_FILE_REMOVAL_COMMAND

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			output_path as command_path,
			serialize as write_command_script
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTION_ENVIRONMENT


feature {NONE} -- Initialization

	make (a_menu_name: like menu_name)
		do
			menu_name := a_menu_name
			script_dir := Directory.Temporary.joined_dir_path (menu_name)
			make_from_file (script_dir + uninstall_script_name)
		end

feature -- Basic operations

	execute
		do
			write_command_script
			command_file.add_permission ("uog", "x")
			Execution.launch (removal_command.to_unicode)
		end

feature {NONE} -- Implementation

	menu_name: ZSTRING

	script_dir: EL_DIR_PATH

	command_file: PLAIN_TEXT_FILE
			--
		do
			create Result.make_with_name (command_path)
		end

	removal_command: ZSTRING
		do
			Result := command_template #$ [command_path]
		end

	uninstall_script_name: ZSTRING
		deferred
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["program_directory",			 agent: EL_PATH do Result := Directory.Application_installation end],
				["software_company_directory", agent: EL_PATH do Result := Directory.Application_installation.parent end ],
				["completion_message",			 agent: ZSTRING do Result := Completion_message_template #$ [menu_name] end]
			>>)
		end

	Template: STRING
		deferred
		end

	command_template: ZSTRING
		deferred
		end

feature {NONE} -- Constants

	Completion_message_template: ZSTRING
		once
			Result := "%"%S%" removed."
		end

end