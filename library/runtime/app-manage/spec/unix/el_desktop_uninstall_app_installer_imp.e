note
	description: "Unix implementation of [$source EL_DESKTOP_UNINSTALL_APP_INSTALLER_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:20:49 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_DESKTOP_UNINSTALL_APP_INSTALLER_IMP

inherit
	EL_DESKTOP_UNINSTALL_APP_INSTALLER_I

	EL_DESKTOP_APPLICATION_INSTALLER_IMP
		rename
			make as make_installer
		redefine
			add_menu_entry, launcher_exists, remove_menu_entry
		end

	EL_MODULE_COMMAND

create
	make

feature -- Status query

	launcher_exists: BOOLEAN
			-- Program listed in Control Panel/Programs and features
		do
		end

feature -- Basic operations

	add_menu_entry
			-- Add program to list in Control Panel/Programs and features
		local
			ico_icon_path, command_path: EL_FILE_PATH
		do
			command_path := Directory.Application_bin + launcher.command
			ico_icon_path := launcher.icon_path.with_new_extension ("ico")
		end

	remove_menu_entry
			-- Remove program from list in Control Panel/Programs and features
		do
		end

feature {NONE} -- Implementation

	estimated_size: INTEGER
			-- estimated size of install in KiB
		local
			directory_size_cmd: like Command.new_directory_info
		do
			directory_size_cmd := Command.new_directory_info (Directory.Application_installation)
			Result := (directory_size_cmd.size / 1024.0).rounded
		end

	display_name: STRING
		do
			Result := launcher.name
		end

end
