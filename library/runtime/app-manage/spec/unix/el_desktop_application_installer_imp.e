note
	description: "[
		Unix implementation of `EL_DESKTOP_APPLICATION_INSTALLER_I' interface
		Creates a GNOME desktop menu application launcher
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 9:55:07 GMT (Friday 1st July 2016)"
	revision: "6"

class
	EL_DESKTOP_APPLICATION_INSTALLER_IMP

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_I

	EL_APPLICATION_INSTALLER_IMP
		undefine
			application_command
		end

	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

	EL_MODULE_BUILD_INFO

	EL_MODULE_OS

create
	make

feature -- Status query

	launcher_exists: BOOLEAN
			--
		do
			Result := (Applications_desktop_dir + desktop_entry.file_name).exists
		end

feature -- Basic operations

	add_menu_entry
			--
		local
			steps: like desktop_entry_path
		do
			steps := desktop_entry_path
			for_each_entry_path_step (steps, agent install_desktop_entry)
			Applications_menu.extend (steps.to_array)
			Applications_menu.serialize_to_file (Applications_menu_file_path)
		end

	remove_menu_entry
			--
		do
			for_each_entry_path_step (desktop_entry_path, agent uninstall_desktop_entry)
			if Applications_menu_file_path.exists then
				OS.delete_file (Applications_menu_file_path)
			end
		end

feature {NONE} -- Implementation

	adjust_path_for_work_bench (dir_path: EL_DIR_PATH)
		local
			l_path: ZSTRING
		do
			l_path := dir_path.parent
			l_path.replace_substring_general_all ("/usr", Directory.Home + ".local")
			l_path.replace_substring_general_all ("/etc/xdg", Directory.Home + ".config")
			dir_path.set_parent_path (l_path)
		end

	desktop_entry: EL_XDG_DESKTOP_LAUNCHER
			--
		do
			create Result.make (submenu_path, launcher)
		end

	desktop_entry_file_path (entry: EL_XDG_DESKTOP_MENU_ITEM): EL_FILE_PATH
			--
		do
			if attached {EL_XDG_DESKTOP_LAUNCHER} entry as application_desktop_entry then
				Result := Applications_desktop_dir + entry.file_name
			else
				Result := Directories_desktop_dir + entry.file_name
			end
		end

	desktop_entry_path: ARRAYED_LIST [EL_XDG_DESKTOP_MENU_ITEM]
			--
		local
			i: INTEGER
		do
			create Result.make (submenu_path.count + 1)
			from i := 1 until i > submenu_path.count loop
				Result.extend (create {EL_XDG_DESKTOP_DIRECTORY}.make (submenu_path.subarray (1, i)))
				i := i + 1
			end
			Result.extend (desktop_entry)
		end

	for_each_entry_path_step (
		entries: like desktop_entry_path
		action: PROCEDURE [like Current, TUPLE [entry: EL_XDG_DESKTOP_MENU_ITEM; file_path: EL_FILE_PATH]]

	)
			--
		do
			from entries.start until entries.after loop
				if not entries.item.is_standard then
					action.call ([entries.item, desktop_entry_file_path (entries.item)])
				end
				entries.forth
			end
		end

	install_desktop_entry (entry: EL_XDG_DESKTOP_MENU_ITEM; file_path: EL_FILE_PATH)
			--
		do
			if not file_path.exists then
				io.put_string ("Creating entry: " + file_path.to_string)
				io.put_new_line
				File_system.make_directory (file_path.parent)
				entry.serialize_to_file (file_path)
			end
		end

	uninstall_desktop_entry (entry: EL_XDG_DESKTOP_MENU_ITEM; file_path: EL_FILE_PATH)
			--
		do
			if file_path.exists then
				io.put_string ("Deleting entry: " + file_path.to_string)
				io.put_new_line
				OS.delete_file (file_path)
			end
		end

feature {EL_DESKTOP_APPLICATION_INSTALLER_I} -- Constants

	Applications_desktop_dir: EL_DIR_PATH
			--
		once
			Result := "/usr/share/applications"
			debug ("installer")
				adjust_path_for_work_bench (Result) -- "/home/finnian/.local/share/applications"
			end
		end

	Applications_menu_file_path: EL_FILE_PATH
			--
		local
			kde_menu_name_parts: EL_ZSTRING_LIST; kde_menu_name: ZSTRING
		do
			create kde_menu_name_parts.make_from_array (<<
				"kde", Build_info.installation_sub_directory.to_string, Environment.execution.Executable_name + ".menu"
			>>)
			kde_menu_name := kde_menu_name_parts.joined ('-')
			kde_menu_name.replace_character ('/', '-')
			Result := XDG_applications_merged_dir + kde_menu_name
		end

	Directories_desktop_dir: EL_DIR_PATH
			--
		once
			Result := "/usr/share/desktop-directories"
			debug ("installer")
				adjust_path_for_work_bench (Result) -- "/home/finnian/.local/share/desktop-directories"
			end
		end

	XDG_applications_merged_dir: EL_DIR_PATH
			--
		once
			Result := "/etc/xdg/menus/applications-merged"
			debug ("installer")
				adjust_path_for_work_bench (Result) -- "/home/finnian/.config/menus/applications-merged"
			end
		end

end