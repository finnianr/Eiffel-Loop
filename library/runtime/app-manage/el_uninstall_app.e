note
	description: "Summary description for {EL_UNINSTALL_DUMMY_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-09-30 18:03:39 GMT (Monday 30th September 2013)"
	revision: "4"

class
	EL_UNINSTALL_APP

inherit
	EL_SUB_APPLICATION
		rename
			make as make_app
		redefine
			option_name, install, installer, is_installable
		end

	EL_MODULE_STRING

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	make (a_app_list: like app_list)
		do
			app_list := a_app_list
			make_app
		end

	initialize
			--
		do
		end

feature -- Basic operations

	run
			--
		do
			io.put_string (String.template (confirmation_prompt_template).substituted (<< Installer.menu_name >>))

			if User_input.entered_letter (yes [1]) then
				io.put_new_line
				io.put_string (commence_message)
				io.put_new_line

				across app_list as application loop
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
			File_system.delete_empty_steps (dir_path.parent.steps)
		end

	install (a_app_list: LIST [EL_SUB_APPLICATION])
		require else
			main_app_exists: across a_app_list as app some app.item.is_main end
		do
			app_list := a_app_list
			Precursor (a_app_list)
		end

	new_installed_file_removal_command: EL_INSTALLED_FILE_REMOVAL_COMMAND
		do
			create {EL_INSTALLED_FILE_REMOVAL_COMMAND_IMPL} Result.make (Installer.menu_name)
		end

	app_list: LIST [EL_SUB_APPLICATION]

feature {NONE} -- Strings

	confirmation_prompt_template: STRING
		do
			Result := "Uninstall application %"$S%". Are you sure? (y/n)"
		end

	commence_message: STRING
		do
			Result := "Uninstalling:"
		end

feature {NONE} -- Constants

	Option_name: STRING = "uninstall"

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
			from app_list.start until app_list.after or app_list.item.is_main loop
				app_list.forth
			end
			if attached {EL_DESKTOP_APPLICATION_INSTALLER} app_list.item.installer as master_app_installer then
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
