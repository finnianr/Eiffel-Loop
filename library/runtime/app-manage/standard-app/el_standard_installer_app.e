note
	description: "[
		Standard command-line installer for application with root conforming to ${EL_MULTI_APPLICATION_ROOT}.
		To use it include the type representation in the list `{EL_MULTI_APPLICATION_ROOT}.application_types'.
		Assumes the following directory structure:
			package/bin/<application name>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "22"

class
	EL_STANDARD_INSTALLER_APP

inherit
	EL_APPLICATION
		rename
			App_directory_list as Root_owned_app_directory_list
		redefine
			option_name, visible_types, do_application
		end

	EL_MODULE_OS

	EL_APPLICATION_CONSTANTS

	EL_SHARED_APPLICATION_LIST; EL_SHARED_INSTALL_UNINSTALL_TESTER

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

	do_application
		local
			parent: DIR_PATH
		do
			-- Change name of data and config directories because they are owned by root
			-- Example: "$HOME/.config/Hex 11 Software/My Ching" becomes "$HOME/.config/Hex 11 Software-installer/My Ching"
			across Root_owned_app_directory_list as path loop
				parent := path.item.parent
				parent.set_base (parent.base + "-installer")
				path.item.set_parent (parent)
			end
			Precursor
			-- delete root owned directories, for example:
			-- "$HOME/.config/Hex 11 Software-installer" + "$HOME/.Hex 11 Software-installer"
			across Root_owned_app_directory_list as path loop
				OS.delete_tree (path.item.parent)
			end
		end

	install_package
			--
		require
			package_installable: is_package_installable
		local
			destination_dir: DIR_PATH
		do
			destination_dir := Directory.Application_installation
			Test_aware.adjust_parent (destination_dir)

			lio.put_labeled_string ("Installing program", Executable.name); lio.put_new_line
			lio.put_path_field ("Source", Package_dir); lio.put_new_line
			lio.put_path_field ("Destination", destination_dir); lio.put_new_line
			lio.put_new_line

			File_system.make_directory (destination_dir)

			OS.find_directories_command (Package_dir).copy_sub_directories (destination_dir)
			OS.find_files_command (Package_dir, "*").copy_directory_files (destination_dir)

			Application_list.install_menus
			lio.put_line ("DONE")
		end

	visible_types: TUPLE [EL_FIND_DIRECTORIES_COMMAND_IMP]
		do
			create Result
		end

feature {NONE} -- Constants

	Description: ZSTRING
		once
			Result := "Installs the application"
		end

	Option_name: IMMUTABLE_STRING_8
		once
			Result := Standard_option.install
		end

end