note
	description: "Windows implementation of [$source EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-20 12:26:10 GMT (Wednesday 20th June 2018)"
	revision: "6"

class
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_IMP

inherit
	EL_UNINSTALL_APP_MENU_DESKTOP_ENV_I
		undefine
			make, Command_args_template
		end

	EL_MENU_DESKTOP_ENVIRONMENT_IMP
		undefine
			command_path
		redefine
			make, add_menu_entry, save_as, launcher_exists, remove_menu_entry, Command_args_template
		end

	EL_MS_WINDOWS_DIRECTORIES

	EL_MODULE_WIN_REGISTRY

	EL_MODULE_REG_KEY

	EL_SHARED_APPLICATION_LIST

create
	make

feature {NONE} -- Initialization

	make (installable: EL_INSTALLABLE_SUB_APPLICATION)
			--
		require else
			main_exists: Application_list.has_main
		do
			Precursor {EL_MENU_DESKTOP_ENVIRONMENT_IMP} (installable)
			uninstall_reg_path := HKLM_uninstall_path.joined_dir_path (main_launcher.name)
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
			set_uninstall_registry_entry ("DisplayVersion", Build_info.version.string)
			set_uninstall_registry_entry ("InstallLocation", Directory.Application_installation)
			set_uninstall_registry_entry ("Publisher", Build_info.installation_sub_directory.steps.first)
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

	save_as (shortcut: EL_SHELL_LINK; file_path: EL_FILE_PATH)
		do
			shortcut.save_elevated (file_path)
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
			list: like File_system.recursive_files; byte_count: INTEGER
		do
			list := File_system.recursive_files (Directory.Application_installation)
			from list.start until list.after loop
				byte_count := byte_count + File_system.file_byte_count (list.item)
				list.forth
			end
			Result := (byte_count / 1024.0).rounded
		end

feature {NONE} -- Internal attributes

	uninstall_reg_path: EL_DIR_PATH

feature {NONE} -- Constants

	Command_args_template: STRING
		once
			create Result.make_empty
		end

	HKLM_uninstall_path: EL_DIR_PATH
		once
			Result := Reg_key.Windows.current_version ("Uninstall")
		end

end
