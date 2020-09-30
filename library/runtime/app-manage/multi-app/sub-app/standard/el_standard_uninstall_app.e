note
	description: "[
		Standard command-line uninstall for application with root conforming to [$source EL_MULTI_APPLICATION_ROOT].
		
		After removing data, configuration and menu files, it generates a forked script to remove the program files
		after the application has exited. The script has a pause in it to allow time for the parent process to exit.
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-30 8:42:33 GMT (Wednesday 30th September 2020)"
	revision: "21"

class
	EL_STANDARD_UNINSTALL_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name, App_directory_list
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

	EL_SHARED_APPLICATION_OPTION

feature {NONE} -- Initialization

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
			lio.put_string_field (Text.uninstall, Application_list.Main_launcher.name)
			lio.put_new_line_x2
			lio.put_string (Text.uninstall_warning)
			lio.put_new_line_x2
			lio.put_string (Text.uninstall_confirmation)

			if User_input.entered_letter (Text.first_letter_yes.to_character_8) then
				lio.put_new_line
				lio.put_line (Text.uninstalling)

				Application_list.uninstall
			else
				-- let the uninstall script know the user changed her mind
				exit_code := 1
			end
		end

feature -- Access

	name: ZSTRING
		do
			Result := Text.uninstall_x #$ [Application_list.Main_launcher.name]
		end

	Option_name: STRING
		once
			Result := Application_option.sub_app.uninstall
		end

feature -- Installer constants

	Desktop: EL_DESKTOP_ENVIRONMENT_I
		once
			if Application_list.has_main then
				create {EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP} Result.make (Current)
			else
				Result := Default_desktop
			end
		end

	Desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			Result := new_launcher ("uninstall.png")
		end

	Desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		once
			Result := << new_category ("System") >>
		end

feature {NONE} -- Application constants

	App_directory_list: EL_ARRAYED_LIST [EL_DIR_PATH]
		-- so nothing is created in /home/root
		once
			create Result.make_empty
		end

	Description: ZSTRING
		once
			if attached Application_list.main as main then
				Result := Text.uninstall_application #$ [main.name]
			else
				Result := Text.uninstall_application #$ ["???"]
			end
		end

	Text: EL_UNINSTALL_TEXTS
		once
			create Result.make
		end

note
	instructions: "[
		**1.** Include the class name EL_STANDARD_UNINSTALL_APP in the generic parameters to class
		[$source EL_MULTI_APPLICATION_ROOT]

			class
				APPLICATION_ROOT

			inherit
				EL_MULTI_APPLICATION_ROOT [
					BUILD_INFO, TUPLE [MY_APP, EL_STANDARD_UNINSTALL_APP]
				]

			create
				make

			end

		**2.** Designate one application to be the "main application" by over-riding
		`{[$source EL_INSTALLABLE_SUB_APPLICATION]}.is_main' with value `True'.

		**3.** By default the launcher menu is put in the System submenu. Over-ride `Desktop_menu_path' to put
		it somewhere else.
	]"

end