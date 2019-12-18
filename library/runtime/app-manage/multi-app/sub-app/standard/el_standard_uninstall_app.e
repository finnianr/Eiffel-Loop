note
	description: "[
		Standard command-line uninstall for application with root conforming to [$source EL_MULTI_APPLICATION_ROOT].
		
		After removing data, configuration and menu files, it generates a forked script to remove the program files
		after the application has exited. The script has a pause in it to allow time for the parent process to exit.
	]"
	instructions: "[
		**1.** Include the type representation `{EL_STANDARD_UNINSTALL_APP}' in the list
		`{EL_MULTI_APPLICATION_ROOT}.application_types'.
		
		**2.** Designate one application to be the "main application" by over-riding
		`{[$source EL_INSTALLABLE_SUB_APPLICATION]}.is_main' with value `True'.
		
		**3.** By default the launcher menu is put in the System submenu. Over-ride `Desktop_menu_path' to put
		it somewhere else.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-18 12:32:04 GMT (Wednesday 18th December 2019)"
	revision: "15"

class
	EL_STANDARD_UNINSTALL_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name, Data_directories
		end

	EL_INSTALLABLE_SUB_APPLICATION
		redefine
			name
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_OS

	EL_MODULE_USER_INPUT

	EL_MODULE_DEFERRED_LOCALE

	EL_SHARED_APPLICATION_LIST
		export
			{ANY} Application_list
		end

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	initialize
			--
		do
		end

feature -- Basic operations

	run
			--
		require else
			has_main_application: Application_list.has_main
		do
			lio.put_string_field (Locale * "Uninstall", Application_list.Main_launcher.name)
			lio.put_new_line_x2
			lio.put_string (Uninstall_warning)
			lio.put_new_line_x2
			lio.put_string (Confirmation_prompt_template)

			if User_input.entered_letter (yes.to_latin_1 [1]) then
				lio.put_new_line
				lio.put_line (Commence_message)
				across Application_list.installable_list as app loop
					app.item.uninstall
				end
				Application_list.uninstall_script.write_remove_directories_script
			else
				-- let the uninstall script know the user changed her mind
				exit_code := 1
			end
		end

feature {EL_UNINSTALL_SCRIPT_I} -- String constants

	Commence_message: ZSTRING
		once
			Result := Locale * "Uninstalling:"
		end

	Confirmation_prompt_template: ZSTRING
		once
			Locale.set_next_translation ("If you are sure press 'y' and <return>:")
			Result := Locale * "{uninstall-confirmation}"
		end

	Name: ZSTRING
		once
			Result := Name_template #$ [Application_list.Main_launcher.name]
		end

	Name_template: ZSTRING
		once
			Locale.set_next_translation ("Uninstall %S")
			Result := Locale * "{uninstall-x}"
		end

	Uninstall_warning: ZSTRING
		once
			Locale.set_next_translation ("THIS ACTION WILL PERMANENTLY DELETE ALL YOUR DATA.")
			Result := Locale * "{uninstall-warning}"
		end

	Yes: ZSTRING
		once
			Result := Locale * "yes"
		end

feature {NONE} -- Installer constants

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher ("uninstall.png")
		end

	Desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		once
			Result := << new_category ("System") >>
		end

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			if Application_list.has_main then
				create {EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP} Result.make (Current)
			else
				Result := Default_desktop
			end
		end

feature {NONE} -- Application constants

	Data_directories: ARRAY [EL_DIR_PATH]
		-- so nothing is created in /home/root
		once
			create Result.make_empty
		end

	Description: ZSTRING
		once
			Locale.set_next_translation ("Uninstall %S application")
			Result := (Locale * "{uninstall-application}") #$ [Application_list.main.name]
		end

	Option_name: STRING
		once
			Result := {EL_COMMAND_OPTIONS}.Uninstall
		end

end
