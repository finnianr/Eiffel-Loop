note
	description: "Standard installer sub-application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 15:09:09 GMT (Sunday 27th May 2018)"
	revision: "1"

class
	EL_STANDARD_INSTALLER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name
		end

	EL_SHARED_APPLICATION_LIST

	EL_INSTALLER_CONSTANTS

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

	EL_MODULE_COMMAND

	EL_MODULE_OS

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			create options_help.make (11)
			create argument_errors.make (0)
		end

	initialize
		do
		end

feature -- Basic operations

	run
		do
			if is_package_installable then
				install_package
			else
				lio.put_string (Error_empty_package_bin)
			end
		end

	install_menus
		do
			across Application_list.installable_list as app loop
				app.item.install
			end
		end

feature -- Status query

	is_package_installable: BOOLEAN
		do
			if Package_dir.exists then
				Result := not named_directory (Package_dir).is_empty
			end
		end

feature {NONE} -- Implementation

	copy_directory (source_dir: EL_DIR_PATH; destination_dir: EL_DIR_PATH)
		do
			lio.put_line (source_dir.to_string)
			lio.put_line (destination_dir.to_string)
			OS.copy_tree (source_dir, destination_dir)
		end

	install_package
			--
		require
			package_installable: is_package_installable
		local
			destination_dir: EL_DIR_PATH; find_directories_cmd: like Command.new_find_directories
		do
			destination_dir := Directory.Application_installation
			debug ("installer")
				destination_dir := Directory.Desktop.joined_dir_path (Build_info.installation_sub_directory)
			end

			lio.put_string (Installing_template #$ [Args.command_name, Package_dir, destination_dir])
			File_system.make_directory (destination_dir)

			find_directories_cmd := Command.new_find_directories (Package_dir)
			find_directories_cmd.set_depth (1 |..| 1)
			find_directories_cmd.execute
			across find_directories_cmd.path_list as source_dir loop
				copy_directory (source_dir.item, destination_dir)
			end
			install_menus
			lio.put_line ("DONE")
		end

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Installs the application"
		end

	Error_empty_package_bin: STRING = "[
		ERROR: No executable found in "package/$PLATFORM_NAME/bin" directory.
		
	]"

	Installing_template: ZSTRING
		once
			Result := "[
				Installing: #
				Source: #
				Destination: #
				
			]"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
		end

	Option_name: STRING
		once
			Result := {EL_COMMAND_OPTIONS}.Install
		end

end
