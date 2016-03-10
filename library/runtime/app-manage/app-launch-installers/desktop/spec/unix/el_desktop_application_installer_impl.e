note
	description: "Creates a GNOME desktop menu application launcher"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:25:21 GMT (Tuesday 18th June 2013)"
	revision: "3"

class
	EL_DESKTOP_APPLICATION_INSTALLER_IMPL

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_I

	EL_SHARED_APPLICATIONS_XDG_DESKTOP_MENU

	EL_MODULE_BUILD_INFO

create
	make, default_create

feature -- Status query

	launcher_exists: BOOLEAN
			--
		do
			Result := (Applications_desktop_dir + desktop_entry.file_name).exists
		end

feature -- Basic operations

	install
			--
		local
			steps: like desktop_entry_path
		do
			steps := desktop_entry_path
			for_each_entry_path_step (steps, agent install_desktop_entry)
			Applications_menu.extend (steps.to_array)
			Applications_menu.save_as_xml (Applications_menu_file_path)
		end

	uninstall
			--
		do
			for_each_entry_path_step (desktop_entry_path, agent uninstall_desktop_entry)
			if Applications_menu_file_path.exists then
				File_system.delete (Applications_menu_file_path)
			end
		end

feature {NONE} -- Implementation

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
				entry.serialize_to_file (file_path)
			end
		end

	uninstall_desktop_entry (entry: EL_XDG_DESKTOP_MENU_ITEM; file_path: EL_FILE_PATH)
			--
		do
			if file_path.exists then
				io.put_string ("Deleting entry: " + file_path.to_string)
				io.put_new_line
				File_system.delete (file_path)
			end
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

	desktop_entry: EL_XDG_DESKTOP_LAUNCHER
			--
		do
			create Result.make (submenu_path, launcher)
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

feature {EL_DESKTOP_APPLICATION_INSTALLER} -- Constants

	Applications_menu_file_path: EL_FILE_PATH
			--
		local
			kde_menu_name: EL_ASTRING_LIST
			kde_menu_name_parts: ARRAY [EL_ASTRING]
		do
			kde_menu_name_parts := <<
				"kde", Build_info.installation_sub_directory.to_string, Execution_environment.Executable_name + ".menu"
			>>
			kde_menu_name := kde_menu_name_parts
			Result := XDG_applications_merged_dir + kde_menu_name.joined_with ('-', False).translated ("/", "-")
		end

--	Command_template: STRING
--			--
--		once
--			Result := "$launch_command -$sub_application_option $command_options"
--		end

	Applications_desktop_dir: EL_DIR_PATH
			--
		once
			Result := "/usr/share/applications"
--			Result := {STRING_32} "/home/finnian/.local/share/applications")
		end

	Directories_desktop_dir: EL_DIR_PATH
			--
		once
			Result := {STRING_32} "/usr/share/desktop-directories"
--			create Result.make_from_string ("/home/finnian/.local/share/desktop-directories")
		end

	XDG_applications_merged_dir: EL_DIR_PATH
			--
		once
			Result := {STRING_32} "/etc/xdg/menus/applications-merged"
--			create Result.make_from_string ("/home/finnian/.config/menus/applications-merged")
		end

end
