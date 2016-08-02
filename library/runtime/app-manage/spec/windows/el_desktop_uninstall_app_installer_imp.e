note
	description: "Windows implementation of `EL_DESKTOP_UNINSTALL_APP_INSTALLER_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 10:02:55 GMT (Friday 24th June 2016)"
	revision: "1"

class
	EL_DESKTOP_UNINSTALL_APP_INSTALLER_IMP

inherit
	EL_DESKTOP_UNINSTALL_APP_INSTALLER_I
		redefine
			make_installer
		end

	EL_DESKTOP_APPLICATION_INSTALLER_IMP
		rename
			make as make_installer
		undefine
			make_installer
		redefine
			add_menu_entry, launcher_exists, remove_menu_entry
		end

	EL_MS_WINDOWS_DIRECTORIES

	EL_MODULE_WIN_REGISTRY

create
	make

feature {NONE} -- Initialization

	make_installer (a_application: EL_SUB_APPLICATION; a_submenu_path: like submenu_path; a_launcher: EL_DESKTOP_LAUNCHER)
			--
		do
			Precursor {EL_DESKTOP_UNINSTALL_APP_INSTALLER_I}  (a_application, a_submenu_path, a_launcher)
			uninstall_reg_path := HKLM_uninstall_path.joined_dir_path (display_name)
		end

feature -- Status query

	launcher_exists: BOOLEAN
			-- Program listed in Control Panel/Programs and features
		do
			Result := Win_registry.has_key (uninstall_reg_path)
		end

feature -- Basic operations

	add_menu_entry
			-- Add program to list in Control Panel/Programs and features
		local
			ico_icon_path, command_path: EL_FILE_PATH
			uninstall_command: EL_ZSTRING_LIST
		do
			command_path := Directory.Application_bin + launcher.command
			ico_icon_path := launcher.icon_path.with_new_extension ("ico")
			uninstall_command := << command_path.to_string.quoted (2), launcher.command_args >>

			set_uninstall_registry_entry ("DisplayIcon", ico_icon_path)
			set_uninstall_registry_entry ("DisplayName", display_name)
			set_uninstall_registry_entry ("Comments", launcher.comment)
			set_uninstall_registry_entry ("DisplayVersion", Build_info.version.string)
			set_uninstall_registry_entry ("InstallLocation", Directory.Application_installation)
			set_uninstall_registry_entry ("Publisher", Build_info.installation_sub_directory.steps.first)
			set_uninstall_registry_entry ("UninstallString", uninstall_command.joined_words)

			set_uninstall_registry_integer_entry ("EstimatedSize", estimated_size)
			set_uninstall_registry_integer_entry ("NoModify", 1)
			set_uninstall_registry_integer_entry ("NoRepair", 1)
		end

	remove_menu_entry
			-- Remove program from list in Control Panel/Programs and features
		do
			if launcher_exists then
				Win_registry.remove_key (HKLM_uninstall_path, display_name)
			end
		end

feature {NONE} -- Implementation

	set_uninstall_registry_entry (name, value: ZSTRING)
		do
			Win_registry.set_string (uninstall_reg_path, name, value)
		end

	set_uninstall_registry_integer_entry (name: ZSTRING; value: INTEGER)
		do
			Win_registry.set_integer (uninstall_reg_path, name, value)
		end

	estimated_size: INTEGER
			-- estimated size of install in KiB
		local
			dir_info_cmd: like Command.new_directory_info
		do
			dir_info_cmd := Command.new_directory_info (Directory.Application_installation)
			dir_info_cmd.execute
			Result := (dir_info_cmd.size / 1024.0).rounded
		end

	display_name: ZSTRING
		do
			Result := launcher.name
		end

feature {NONE} -- Internal attributes

	uninstall_reg_path: EL_DIR_PATH

feature {NONE} -- Constants

	HKLM_uninstall_path: EL_DIR_PATH
		once
			Result := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
		end

end