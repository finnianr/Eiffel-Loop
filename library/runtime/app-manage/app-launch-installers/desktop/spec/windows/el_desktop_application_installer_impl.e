note
	description: "Windows implementation"

	notes: "[
		In Windows 2000, Windows XP, and Windows Server 2003, the folder is located in %userprofile%\Start Menu for individual users, 
		or %allusersprofile%\Start Menu for all users collectively.
		
		In Windows Vista and Windows 7, the folder is located in %appdata%\Microsoft\Windows\Start Menu for individual users, 
		or %programdata%\Microsoft\Windows\Start Menu for all users collectively.
		
		The folder name Start Menu has a different name on non-English versions of Windows. 
		Thus for example on German versions of Windows XP it is %userprofile%\Startmenü.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:20 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_DESKTOP_APPLICATION_INSTALLER_IMPL

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_I
		redefine
			make
		end

	EL_MS_WINDOWS_DIRECTORIES

create
	make, default_create

feature {NONE} -- Initialization

	make (a_interface: like interface)
			--

		do
			Precursor (a_interface)
			create submenu_steps.make_filled ("", 1, submenu_path.count)
			submenu_path.do_all_with_index (
				agent (menu: EL_DESKTOP_MENU_ITEM; index: INTEGER)
					do
						submenu_steps [index] := menu.name
					end
			)
			application_menu_dir := Start_menu_programs_dir.joined_dir_steps (submenu_steps)
			shortcut_path := application_menu_dir + shortcut_name
		end

feature -- Status query

	launcher_exists: BOOLEAN
			--
		do
			Result := shortcut_path.exists
		end

feature -- Basic operations

	install
			--
		local
			shortcut: EL_SHELL_LINK
			ico_icon_path, command_path: EL_FILE_PATH
		do
			command_path := Execution.Application_bin_path + launcher.command
			ico_icon_path := launcher.icon_path.with_new_extension ("ico")

			if not application_menu_dir.exists then
				File_system.make_directory (application_menu_dir)
			end
			create shortcut.make
			shortcut.set_command_arguments (launcher.command_args)
			shortcut.set_target_path (command_path)
			shortcut.set_icon_location (ico_icon_path, 1)
			shortcut.set_description (launcher.comment)
			across << shortcut_path, desktop_shortcut_path >> as l_path loop
				if not l_path.item.is_empty then
					shortcut.save (l_path.item)
				end
			end
		end

	uninstall
			--
		do
			across << shortcut_path, desktop_shortcut_path >> as l_path loop
				if l_path.item.exists then
					File_system.delete (l_path.item)
				end
			end
			File_system.delete_empty_steps (application_menu_dir)
		end

feature {NONE} -- Implementation

	desktop_shortcut_path: EL_FILE_PATH
		do
			if has_desktop_launcher then
				Result := Desktop_dir + shortcut_name
			else
				create Result
			end
		end

	shortcut_name: EL_ASTRING
		do
			Result := launcher.name + ".lnk"
		end

	submenu_steps: ARRAY [STRING]

	shortcut_path: EL_FILE_PATH

	application_menu_dir: EL_DIR_PATH

end
