note
	description: "Summary description for {EL_UNINSTALL_DUMMY_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 9:54:00 GMT (Friday 1st July 2016)"
	revision: "7"

class
	EL_UNINSTALL_APP

inherit
	EL_INSTALLER_SUB_APPLICATION
		redefine
			option_name, installer, is_installable
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_OS

	EL_MODULE_USER_INPUT
	
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
		local
			dir_path: EL_DIR_PATH
		do
			io.put_string (confirmation_prompt_template.substituted_tuple ([Installer.menu_name]).to_utf_8)

			if User_input.entered_letter (yes.to_latin_1 [1]) then
				io.put_new_line
				io.put_string (Commence_message.to_utf_8)
				io.put_new_line

				across sub_applications as application loop
					if application.item.is_installable then
						application.item.uninstall
					end
				end
				-- Remove application data and configuration directories for all users
				across OS.user_list as user loop
					across For_user_directories as user_dir loop
						dir_path := user_dir.item (user.item)
						if dir_path.exists then
							delete_dir_tree (dir_path)
						end
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
			OS.delete_tree (dir_path)
			File_system.delete_empty_branch (dir_path.parent)
		end

	new_installed_file_removal_command: EL_INSTALLED_FILE_REMOVAL_COMMAND
		do
			create {EL_INSTALLED_FILE_REMOVAL_COMMAND_IMP} Result.make (Installer.menu_name)
		end

feature {NONE} -- Constants

	Option_name: STRING = "uninstall"

	Commence_message: ZSTRING
		once
			Result := "Uninstalling:"
		end

	Confirmation_prompt_template: ZSTRING
		once
			Result := "Uninstall application %"%S%". Are you sure? (y/n)"
		end

	Description: STRING
		once
			Result := "Uninstall application"
		end

	Yes: ZSTRING
		once
			Result := "yes"
		end

	Installer: EL_APPLICATION_INSTALLER_I
		once
			from sub_applications.start until sub_applications.after or sub_applications.item.is_main loop
				sub_applications.forth
			end
			if attached {EL_DESKTOP_APPLICATION_INSTALLER_I} sub_applications.item.installer as master_app_installer then
				create {EL_DESKTOP_UNINSTALL_APP_INSTALLER_IMP} Result.make (Current, master_app_installer.launcher)
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
