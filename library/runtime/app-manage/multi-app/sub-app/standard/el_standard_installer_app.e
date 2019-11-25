note
	description: "[
		Standard command-line installer for application with root conforming to [$source EL_MULTI_APPLICATION_ROOT].
		To use it include the type representation in the list `{EL_MULTI_APPLICATION_ROOT}.application_types'.
		Assumes the following directory structure:
			package/bin/<application name>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-25 11:48:03 GMT (Monday 25th November 2019)"
	revision: "9"

class
	EL_STANDARD_INSTALLER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			option_name, visible_types
		end

	EL_SHARED_APPLICATION_LIST

	EL_INSTALLER_CONSTANTS

	EL_MODULE_COMMAND

	EL_MODULE_OS

	EL_INSTALLER_DEBUG

	EL_SHARED_DIRECTORY
		rename
			Directory as OS_directory
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
			if is_package_installable then
				install_package
			else
				if not Package_dir.exists then
					lio.put_labeled_substitution ("ERROR", "Package directory does not exist")
				else
					lio.put_labeled_substitution ("ERROR", "Package directory is empty")
				end
				lio.put_new_line
				lio.put_path_field ("Package", Package_dir)
				lio.put_new_line
			end
		end

feature -- Status query

	is_package_installable: BOOLEAN
		do
			if Package_dir.exists then
				Result := not OS_directory.named (Package_dir).is_empty
			end
		end

feature {NONE} -- Implementation

	install_package
			--
		require
			package_installable: is_package_installable
		local
			destination_dir: EL_DIR_PATH
		do
			destination_dir := Directory.Application_installation
			if_installer_debug_enabled (destination_dir)

			lio.put_labeled_string ("Installing program", Execution_environment.executable_name); lio.put_new_line
			lio.put_path_field ("Source", Package_dir); lio.put_new_line
			lio.put_path_field ("Destination", destination_dir); lio.put_new_line
			lio.put_new_line

			File_system.make_directory (destination_dir)

			Command.new_find_directories (Package_dir).copy_sub_directories (destination_dir)
			Command.new_find_files (Package_dir, "*").copy_directory_files (destination_dir)

			Application_list.install_menus
			lio.put_line ("DONE")
		end

	visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		do
			Result := << {EL_FIND_DIRECTORIES_COMMAND_IMP} >>
		end

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Installs the application"
		end

	Option_name: STRING
		once
			Result := {EL_COMMAND_OPTIONS}.Install
		end

end
