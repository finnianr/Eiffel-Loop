note
	description: "Debian package command that will create a Debian package for current application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 20:25:17 GMT (Tuesday   1st   October   2019)"
	revision: "3"

class
	EL_DEBIAN_PACKAGER

inherit
	EL_COMMAND

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_DEBIAN_CONSTANTS

	EL_MODULE_BUILD_INFO
	EL_MODULE_COLON_FIELD
	EL_MODULE_COMMAND
	EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM

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
		end

feature -- Basic operations

	execute
		local
			control_file: EL_DEBIAN_CONTROL; destination_dir: EL_DIR_PATH
		do
			destination_dir := application_output_dir
			File_system.make_directory (destination_dir)
			Command.new_find_directories (package_dir).copy_sub_directories (destination_dir)
			Command.new_find_files (package_dir, All_files).copy_directory_files (destination_dir)

			create control_file.make (template_dir + Control, debian_output_dir + Control)
			control_file.set_installed_size (Command.new_find_files (package_dir, All_files).sum_file_byte_count)
			control_file.serialize
		end

feature {NONE} -- Implementation

	application_output_dir: EL_DIR_PATH
		do
			Result := output_dir.joined_dir_tuple ([
				versioned_package, Directory.Application_installation.relative_path (Root_dir)
			])
		end

	debian_output_dir: EL_DIR_PATH
		do
			Result := output_dir.joined_dir_tuple ([versioned_package, once "DEBIAN"])
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

feature {NONE} -- Constants

	All_files: STRING = "*"

	Name_template: ZSTRING
		once
			Result := "%S-%S"
		end

	Root_dir: EL_DIR_PATH
		once
			Result := "/"
		end

end
