note
	description: "Windows implementation of ${EL_MENU_DESKTOP_ENVIRONMENT_I} interface"
	notes: "[
		In Windows 2000, Windows XP, and Windows Server 2003, the folder is located in %userprofile%\Start Menu for individual users, 
		or %allusersprofile%\Start Menu for all users collectively.
		
		In Windows Vista and Windows 7, the folder is located in %appdata%\Microsoft\Windows\Start Menu for individual users, 
		or %programdata%\Microsoft\Windows\Start Menu for all users collectively.
		
		The folder name Start Menu has a different name on non-English versions of Windows. 
		Thus for example on German versions of Windows XP it is %userprofile%\Startmenü.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-28 7:04:10 GMT (Friday 28th June 2024)"
	revision: "18"

class
	EL_MENU_DESKTOP_ENVIRONMENT_IMP

inherit
	EL_MENU_DESKTOP_ENVIRONMENT_I
		undefine
			command_path
		redefine
			make
		end

	EL_DESKTOP_ENVIRONMENT_IMP
		undefine
			make, application_command
		end

	EL_MS_WINDOWS_DIRECTORIES

create
	make

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_APPLICATION)
			--
		do
			Precursor {EL_MENU_DESKTOP_ENVIRONMENT_I} (installable)
			application_menu_dir := Start_menu_programs_dir #+ submenu_path_steps
			shortcut_path := application_menu_dir + shortcut_name
		end

feature -- Access

	shortcut_path: FILE_PATH

feature -- Status query

	launcher_exists: BOOLEAN
			--
		do
			Result := shortcut_path.exists
		end

feature -- Basic operations

	add_menu_entry
			--
		local
			shortcut: COM_SHELL_LINK
		do
			if not application_menu_dir.exists then
				File_system.make_directory (application_menu_dir)
			end
			create shortcut.make
			shortcut.set_elevated (Has_elevated)
			shortcut.set_arguments (command_args)
			shortcut.set_target_path (command_path)
			shortcut.set_icon ([launcher.windows_icon_path, 1])
			shortcut.set_description (launcher.comment)

			shortcut.save (shortcut_path)
			if has_desktop_launcher then
				shortcut.save (desktop_shortcut_path)
			end
		end

	remove_menu_entry
			--
		do
			across << shortcut_path, desktop_shortcut_path >> as l_path loop
				if l_path.item.exists then
					File_system.remove_file (l_path.item)
				end
			end
			File_system.delete_empty_branch (application_menu_dir)
		end

feature -- Element change

	set_shortcut_path (a_shortcut_path: FILE_PATH)
		do
			shortcut_path := a_shortcut_path
		end

feature {NONE} -- Implementation

	desktop_shortcut_path: FILE_PATH
		do
			Result := Desktop_common + shortcut_name
		end

	shortcut_name: ZSTRING
		do
			Result := launcher.name + ".lnk"
		end

	submenu_path_steps: EL_PATH_STEPS
		do
			create Result.make_steps (submenu_path.count)
			across submenu_path as submenu loop
				Result.extend (submenu.item.name)
			end
		end

feature {NONE} -- Internal attributes

	application_menu_dir: DIR_PATH

feature {NONE} -- Constants

	Has_elevated: BOOLEAN
		-- `True' if saved shortcut has ability to launch with elevated privileges
		once
			Result := False
		end

end