note
	description: "Windows implementation of ${EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-30 9:10:32 GMT (Thursday 30th November 2023)"
	revision: "17"

class
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP

inherit
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I
		undefine
			application_command, make, Command_args_template
		end

	EL_MENU_DESKTOP_ENVIRONMENT_IMP
		undefine
			launch_command, command_path
		redefine
			make, add_menu_entry, has_elevated, launcher_exists, remove_menu_entry, Command_args_template
		end

	EL_MS_WINDOWS_DIRECTORIES

	EL_MODULE_FILE; EL_MODULE_WIN_REGISTRY; EL_MODULE_REG_KEY

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

feature -- Status query

	launcher_exists: BOOLEAN
			-- Program listed in Control Panel/Programs and features
		do
			Result := Win_registry.has_key (uninstall_reg_path)
		end

feature -- Basic operations

	add_menu_entry
			-- Add program to list in Control Panel/Programs and features
		do
			Precursor
			set_uninstall_registry_entry ("DisplayIcon", main_launcher.windows_icon_path)
			set_uninstall_registry_entry ("DisplayName", main_launcher.name)
			set_uninstall_registry_entry ("Comments", launcher.comment)
			set_uninstall_registry_entry ("DisplayVersion", Software_version.string)
			set_uninstall_registry_entry ("InstallLocation", Directory.Application_installation)
			set_uninstall_registry_entry ("Publisher", Build_info.installation_sub_directory.first_step)
			set_uninstall_registry_entry ("UninstallString", command_path.escaped)

			set_uninstall_registry_integer_entry ("EstimatedSize", estimated_size)
			set_uninstall_registry_integer_entry ("NoModify", 1)
			set_uninstall_registry_integer_entry ("NoRepair", 1)
		end

	remove_menu_entry
			-- Remove program from list in Control Panel/Programs and features
		do
			Precursor
			if launcher_exists then
				Win_registry.remove_key (HKLM_uninstall_path, main_launcher.name)
			end
		end

feature {NONE} -- Implementation

	main_launcher: EL_DESKTOP_MENU_ITEM
		do
			Result := Application_list.Main_launcher
		end

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

feature {NONE} -- Internal attributes

	uninstall_reg_path: DIR_PATH

feature {NONE} -- Constants

	Command_args_template: STRING
		once
			-- If left empty you get a "template not found" exception
			Result := "$command_options"
		end

	Has_elevated: BOOLEAN = True
		-- `True' if saved shortcut has ability to launch with elevated privileges

	HKLM_uninstall_path: DIR_PATH
		once
			Result := Reg_key.Windows.current_version ("Uninstall")
		end

end