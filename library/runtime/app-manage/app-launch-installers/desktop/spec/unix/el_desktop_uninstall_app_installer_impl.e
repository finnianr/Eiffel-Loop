note
	description: "Summary description for {EL_DESKTOP_UNINSTALL_APP_INSTALLER_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-19 13:12:05 GMT (Wednesday 19th June 2013)"
	revision: "2"

class
	EL_DESKTOP_UNINSTALL_APP_INSTALLER_IMPL

inherit
	EL_DESKTOP_APPLICATION_INSTALLER_I
		redefine
			make
		end

	EL_MODULE_BUILD_INFO

	EL_MODULE_STRING

create
	make, default_create

feature {NONE} -- Initialization

	make (a_interface: like interface)
			--
		do
			Precursor (a_interface)
		end

feature -- Status query

	launcher_exists: BOOLEAN
			-- Program listed in Control Panel/Programs and features
		do
		end

feature -- Basic operations

	install
			-- Add program to list in Control Panel/Programs and features
		local
			ico_icon_path, command_path: EL_FILE_PATH
		do
			command_path := Execution.Application_bin_path + launcher.command
			ico_icon_path := launcher.icon_path.with_new_extension ("ico")
		end

	uninstall
			-- Remove program from list in Control Panel/Programs and features
		do
		end

feature {NONE} -- Implementation

	estimated_size: INTEGER
			-- estimated size of install in KiB
		local
			directory_size_cmd: EL_DIRECTORY_INFO_COMMAND
		do
			create directory_size_cmd.make (Execution.Application_installation_dir)
			directory_size_cmd.execute
			Result := (directory_size_cmd.size / 1024.0).rounded
		end

	display_name: STRING
		do
			Result := launcher.name
		end


end
