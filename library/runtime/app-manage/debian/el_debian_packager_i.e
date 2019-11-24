note
	description: "[
		Command that will create a Debian install package for current application defined as root class
		inheriting [$source EL_MULTI_APPLICATION_ROOT]. At least one sub-application must conform
		to [$source EL_INSTALLABLE_SUB_APPLICATION].
		
		By including the sub-application [$source EL_DEBIAN_PACKAGER_APP], the application is capable of generating
		it's own install package.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 18:52:04 GMT (Sunday 24th November 2019)"
	revision: "6"

deferred class
	EL_DEBIAN_PACKAGER_I

inherit
	EL_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_SHARED_APPLICATION_LIST

	EL_DEBIAN_CONSTANTS

	EL_MODULE_BUILD_INFO
	EL_MODULE_COLON_FIELD
	EL_MODULE_COMMAND
	EL_MODULE_DIRECTORY
	EL_MODULE_OS

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_debian_dir, a_output_dir, a_package_dir: EL_DIR_PATH)
		local
			lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			debian_dir := a_debian_dir; output_dir := a_output_dir; package_dir := a_package_dir
			make_machine
			create package.make_empty
			create lines.make (debian_dir + Control)
			do_once_with_file_lines (agent find_package, lines)
			versioned_package := Name_template #$ [package, Build_info.version.string]
			versioned_package_dir := Directory.temporary.joined_dir_tuple ([versioned_package])
		end

feature -- Basic operations

	execute
		do
			put_opt_contents; put_xdg_entries; put_control_files

			Debian_build.put_directory_path (Var_path, versioned_package_dir)
			Debian_build.execute

			OS.delete_tree (versioned_package_dir)
			OS.move_file (package_file_path, output_dir)
		end

feature {NONE} -- Implementation

	installed_size: NATURAL
		do
			Result := Command.new_find_files (package_dir, All_files).sum_file_byte_count
		end

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

	put_control_files
		-- copy control file and any installer scripts
		local
			control_file: EL_DEBIAN_CONTROL; destination_path: EL_FILE_PATH
		do
			across Shared_directory.named (debian_dir).files as file_path loop
				destination_path := versioned_package_dir.joined_file_tuple ([once "DEBIAN", file_path.item.base])
				if file_path.item.base ~ Control then
					create control_file.make (file_path.item, destination_path)
					control_file.set_installed_size (installed_size)
					control_file.serialize
				elseif file_path.item.extension /~ Evc_extension then
					OS.copy_file (file_path.item, destination_path)
				end
			end
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
		-- Write XDG desktop entries on Unix
		-- Do nothing on Windows
		deferred
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

	debian_dir: EL_DIR_PATH
		-- directory with Control template and scripts

	versioned_package: ZSTRING
		-- package name with appended version

	versioned_package_dir: EL_DIR_PATH

feature {NONE} -- Constants

	Debian_build: EL_OS_COMMAND
		once
			create Result.make ("dpkg-deb --build $" + Var_path)
		end

	Evc_extension: ZSTRING
		-- Compiled Evolicity extension
		once
			Result := "evc"
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
