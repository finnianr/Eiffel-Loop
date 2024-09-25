note
	description: "Windows implementation of ${EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 7:54:42 GMT (Wednesday 25th September 2024)"
	revision: "20"

class
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP

inherit
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I
		undefine
			application_command, make, install, uninstall,
			Command_args_template
		end

	EL_MENU_DESKTOP_ENVIRONMENT_IMP
		undefine
			launch_command, command_path
		redefine
			make, install, has_elevated, launcher_exists, uninstall,
			Command_args_template
		end

	EL_MS_WINDOWS_DIRECTORIES

	EL_MODULE_FILE; EL_MODULE_WIN_REGISTRY; EL_MODULE_HKEY_LOCAL_MACHINE

	EL_SHARED_APPLICATION_LIST; EL_SHARED_SOFTWARE_VERSION

create
	make

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_APPLICATION)
			--
		require else
			main_exists: Application_list.has_main
		do
			Precursor {EL_MENU_DESKTOP_ENVIRONMENT_IMP} (installable)
			uninstall_reg_path := HKLM_uninstall_path #+ main_launcher.name
		end

feature -- Access

	registered_display_name: ZSTRING
		do
			Result := Win_registry.string (HKLM_uninstall_path #+ main_launcher.name, Key_display_name)
		end

	registered_estimated_size: INTEGER
		do
			Result := Win_registry.integer (HKLM_uninstall_path #+ main_launcher.name, Key_estimated_size)
		end

feature -- Measurement

	estimated_size: INTEGER
		-- estimated size of install in KiB
		local
			byte_count: INTEGER
		do
			if attached File_system.files (Directory.Application_installation, True) as list then
				from list.start until list.after loop
					byte_count := byte_count + File.byte_count (list.path)
					list.forth
				end
			end
			Result := (byte_count / 1024.0).rounded
		end

feature -- Status query

	has_uninstall_entries: BOOLEAN
		do
			Result := Win_registry.has_key (HKLM_uninstall_path #+ main_launcher.name)
		end

	launcher_exists: BOOLEAN
			-- Program listed in Control Panel/Programs and features
		do
			Result := Win_registry.has_key (uninstall_reg_path)
		end

feature -- Basic operations

	install
		-- Add program to list in Control Panel/Programs and features
		do
			Precursor {EL_MENU_DESKTOP_ENVIRONMENT_IMP}
			install_registry_entries
		end

	uninstall
		-- Remove program from list in Control Panel/Programs and features
		do
			Precursor {EL_MENU_DESKTOP_ENVIRONMENT_IMP}
			uninstall_registry_entries
		end

feature {NONE} -- Implementation

	install_registry_entries
		-- install registry entries with uninstall information
		do
			set_uninstall_registry_entry ("DisplayIcon", main_launcher.windows_icon_path)
			set_uninstall_registry_entry (Key_display_name, main_launcher.name)
			set_uninstall_registry_entry ("Comments", launcher.comment)
			set_uninstall_registry_entry ("DisplayVersion", Software_version.string)
			set_uninstall_registry_entry ("InstallLocation", Directory.Application_installation)
			set_uninstall_registry_entry ("Publisher", Build_info.installation_sub_directory.first_step)
			set_uninstall_registry_entry ("UninstallString", command_path.escaped)

			set_uninstall_registry_integer_entry (Key_estimated_size, estimated_size)
			set_uninstall_registry_integer_entry ("NoModify", 1)
			set_uninstall_registry_integer_entry ("NoRepair", 1)
		end

	main_launcher: EL_DESKTOP_MENU_ITEM
		do
			Result := Application_list.Main_launcher
		end

	set_uninstall_registry_entry (name, value: READABLE_STRING_GENERAL)
		do
			Win_registry.set_string (uninstall_reg_path, name, value)
		end

	set_uninstall_registry_integer_entry (name: READABLE_STRING_GENERAL; value: INTEGER)
		do
			Win_registry.set_integer (uninstall_reg_path, name, value)
		end

	uninstall_registry_entries
		-- remove registry entries with uninstall information
		do
			if has_uninstall_entries then
				Win_registry.remove_key (HKLM_uninstall_path, main_launcher.name)
			end
		end

feature {NONE} -- Internal attributes

	uninstall_reg_path: DIR_PATH

feature {NONE} -- Constants

	Command_args_template: STRING
		once
			-- If left empty you get a "template not found" exception
			Result := "$command_options"
		end

	Key_display_name: STRING = "DisplayName"

	Key_estimated_size: STRING = "EstimatedSize"

	HKLM_uninstall_path: DIR_PATH
		-- HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
		once
			Result := Key_local.Microsoft_windows #+ "CurrentVersion\Uninstall"
		end

	Has_elevated: BOOLEAN = True
		-- `True' if saved shortcut has ability to launch with elevated privileges

end