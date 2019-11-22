note
	description: "[
		Command that will create a Debian install package for current application defined as root class
		inheriting [$source EL_MULTI_APPLICATION_ROOT]. At least one sub-application must conform
		to [$source EL_INSTALLABLE_SUB_APPLICATION].
		
		By including the sub-application [$source EL_DEBIAN_PACKAGER_APP], the application is capable of generating
		it's own install package. The
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-22 17:22:02 GMT (Friday 22nd November 2019)"
	revision: "5"

class
	EL_DEBIAN_PACKAGER

inherit
	EL_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_SHARED_APPLICATION_LIST

	EL_DEBIAN_CONSTANTS

	EL_XDG_CONSTANTS
		rename
			Applications_menu as Default_applications_menu
		end

	EL_MODULE_BUILD_INFO
	EL_MODULE_COLON_FIELD
	EL_MODULE_COMMAND
	EL_MODULE_DIRECTORY
	EL_MODULE_OS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_template_dir, a_output_dir, a_package_dir: EL_DIR_PATH)
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			template_dir := a_template_dir; output_dir := a_output_dir; package_dir := a_package_dir
			make_machine
			create package.make_empty
			create lines.make (template_dir + Control)
			do_once_with_file_lines (agent find_package, lines)
			versioned_package := Name_template #$ [package, Build_info.version.string]
			versioned_package_dir := Directory.temporary.joined_dir_tuple ([versioned_package])
		end

feature -- Basic operations

	execute
		do
			put_opt_contents; put_xdg_entries; put_control_file

			Debian_build.put_directory_path (Var_path, versioned_package_dir)
			Debian_build.execute

			OS.delete_tree (versioned_package_dir)
			OS.move_file (package_file_path, output_dir)
		end

feature {NONE} -- Implementation

	package_file_path: EL_FILE_PATH
		do
			Result := versioned_package_dir.to_string
			Result.add_extension ("deb")
		end

	package_sub_dir (absolute_dir: EL_DIR_PATH): EL_DIR_PATH
		require
			is_absolute: absolute_dir.is_absolute
		do
			Result := versioned_package_dir.joined_dir_path (absolute_dir.relative_path (Root_dir))
		end

	put_control_file
		local
			control_file: EL_DEBIAN_CONTROL; control_file_path: EL_FILE_PATH
		do
			control_file_path := versioned_package_dir.joined_file_tuple ([once "DEBIAN", Control])
			create control_file.make (template_dir + Control, control_file_path)
			control_file.set_installed_size (Command.new_find_files (package_dir, All_files).sum_file_byte_count)
			control_file.serialize
		end

	put_opt_contents
		local
			destination_dir: EL_DIR_PATH
		do
			destination_dir := package_sub_dir (Directory.Application_installation)

			OS.File_system.make_directory (destination_dir)
			Command.new_find_directories (package_dir).copy_sub_directories (destination_dir)
			Command.new_find_files (package_dir, All_files).copy_directory_files (destination_dir)
		end

	put_xdg_entries
		local
			menu_desktop: EL_MENU_DESKTOP_ENVIRONMENT_IMP
			applications_menu: EL_XDG_DESKTOP_MENU
		do
			create applications_menu.make_root (package_sub_dir (Applications_merged_dir))
			across Application_list.installable_list as installable loop
				create menu_desktop.make_with_output (
					installable.item, package_sub_dir (Applications_desktop_dir), package_sub_dir (Directories_desktop_dir)
				)
				menu_desktop.install_entry_steps
				applications_menu.extend (menu_desktop.entry_steps)
			end
			applications_menu.serialize
		end

feature {NONE} -- Line states

	find_package (line: ZSTRING)
		do
			if Colon_field.name (line) ~ Field_package then
				package := Colon_field.value (line)
				state := final
			end
		end

feature {NONE} -- Internal attributes

	output_dir: EL_DIR_PATH

	package: ZSTRING
		-- package name

	package_dir: EL_DIR_PATH

	template_dir: EL_DIR_PATH

	versioned_package: ZSTRING
		-- package name with appended version

	versioned_package_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Debian_build: EL_OS_COMMAND
		once
			create Result.make ("dpkg-deb --build $" + Var_path)
		end

	All_files: STRING = "*"

	Name_template: ZSTRING
		once
			Result := "%S-%S"
		end

	Root_dir: EL_DIR_PATH
		once
			Result := "/"
		end

	Var_path: STRING = "path"

end
