note
	description: "[
		Delayed removal of program directory on uninstall to avoid permission problem
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_INSTALLED_FILE_REMOVAL_COMMAND

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			make as make_serializeable,
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
			Execution.launch (removal_command.to_unicode)
		end

feature {NONE} -- Implementation

	menu_name: EL_ASTRING

	script_dir: EL_DIR_PATH

	removal_command: EL_ASTRING
		do
			Result := command_template.substituted (<< command_path >>)
		end

	uninstall_script_name: EL_ASTRING
		deferred
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["program_directory", agent: EL_ASTRING
					do
						Result := Execution.Application_installation_dir.to_string
					end
				],
				["software_company_directory", agent: EL_ASTRING
					do
						Result := Execution.Application_installation_dir.parent.to_string
					end
				],
				["completion_message", agent: EL_ASTRING
					do
						Result := String.template (completion_message_template).substituted (<< menu_name >>)
					end
				]
			>>)
		end

	Template: STRING
		deferred
		end

	command_template: EL_TEMPLATE_STRING
		deferred
		end

feature {NONE} -- Constants

	completion_message_template: EL_ASTRING
		do
			Result := "%"$S%" removed."
		end

end
