note
	description: "Summary description for {EL_UNINSTALL_DUMMY_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-02 13:16:38 GMT (Sunday 2nd March 2014)"
	revision: "5"

class
	EL_UNINSTALL_APP

inherit
	EL_INSTALLER_SUB_APPLICATION
		redefine
			option_name, installer, is_installable
		end

	EL_MODULE_STRING

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make_installer

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	initialize
			--
		do
		end

feature -- Basic operations

	run
			--
		do
			io.put_string (confirmation_prompt_template #$ [Installer.menu_name])

			if User_input.entered_letter (yes [1]) then
				io.put_new_line
				io.put_string (commence_message)
				io.put_new_line

				across sub_applications as application loop
					if application.item.is_installable then
						application.item.uninstall
					end
				end
				across User_data_directories as data_directory loop
					if data_directory.item.exists then
						delete_dir_tree (data_directory.item)
					end
				end
				new_installed_file_removal_command.execute
			end
		end

feature -- Status query

	is_installable: BOOLEAN = True

feature {NONE} -- Implementation

	delete_dir_tree (dir_path: EL_DIR_PATH)
		do
			File_system.delete_tree (dir_path)
			File_system.delete_empty_branch (dir_path.parent)
		end

	new_installed_file_removal_command: EL_INSTALLED_FILE_REMOVAL_COMMAND
		do
			create {EL_INSTALLED_FILE_REMOVAL_COMMAND_IMPL} Result.make (Installer.menu_name)
		end

feature {NONE} -- Strings

	commence_message: STRING
		do
			Result := "Uninstalling:"
		end

feature {NONE} -- Constants

	Option_name: STRING = "uninstall"

	Confirmation_prompt_template: ASTRING
		once
			Result := "Uninstall application %"$S%". Are you sure? (y/n)"
		end

	Description: STRING
		once
			Result := "Uninstall application"
		end

	Yes: STRING
		once
			Result := "yes"
		end

	Installer: EL_APPLICATION_INSTALLER
		once
			from sub_applications.start until sub_applications.after or sub_applications.item.is_main loop
				sub_applications.forth
			end
			if attached {EL_DESKTOP_APPLICATION_INSTALLER} sub_applications.item.installer as master_app_installer then
				create {EL_DESKTOP_UNINSTALL_APP_INSTALLER} Result.make (Current, master_app_installer.launcher)
			else
				Result := Precursor
			end
			Result.set_command_line_options ("-console_on")
		end

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_UNINSTALL_APP}, "*"]
			>>
		end

end
