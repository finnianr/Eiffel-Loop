note
	description: "[
		Command to build an application and then package it as a self-extracting winzip exe installer.
	]"
	notes: "[
		Requires that the WinZip command-line utility `wzipse32' is installed and in the search path.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-06 16:43:00 GMT (Friday 6th August 2021)"
	revision: "14"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER

inherit
	EL_COMMAND

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_DIRECTORY

	EL_MODULE_EXECUTABLE

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	WINZIP_SOFTWARE_COMMON

	EL_STRING_8_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config_path, a_pecf_path: EL_FILE_PATH)
		require
			path_exits: a_pecf_path.exists
			root_class_exists: root_class_exists (a_pecf_path)
		local
			scanner: PYXIS_ECF_SCANNER
		do
			pecf_path := a_pecf_path
			create project_py_swapper.make (Project_py, "py32")
			create scanner.make (a_pecf_path)
			create package.make (a_config_path, scanner.new_software_info)
		end

feature -- Status query

	has_build_error: BOOLEAN

feature -- Basic operations

	execute
		local
			architecture_list: EL_SORTABLE_ARRAYED_LIST [INTEGER]
		do
			create architecture_list.make_from_list (package.architecture_list)
			architecture_list.reverse_sort
			package.check_validity
			if package.is_valid then
				lio.put_path_field ("Output", package.output_dir)
				lio.put_new_line
				lio.put_path_field ("Project", pecf_path)
				lio.put_new_line
				if architecture_list.count > 0 then
					if architecture_list.has (64) then
						package.software.increment_pecf_build (pecf_path)
					end
					package.pass_phrase.share (User_input.line ("Signing pass phrase"))
					lio.put_new_line
				end
				across architecture_list as bit_count until has_build_error loop
					if package.build_exe then
						if bit_count.item = 32 implies project_py_swapper.replacement_path.exists then
							build_exe (bit_count.item, bit_count.item = 64)
							if not has_build_error then
								package.sha_256_sign_software_exe (bit_count.item)
							end
						else
							lio.put_labeled_string (project_py_swapper.replacement_path, " is missing")
							lio.put_new_line
							has_build_error := True
						end
					end
					if package.build_installers and then not has_build_error then
						if not package.output_dir.exists then
							File_system.make_directory (package.output_dir)
						end
						across package.language_list as lang until has_build_error loop
							package.build_installer (Locale.in (lang.item), bit_count.item)
							has_build_error := package.has_build_error
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	build_exe (bit_count: INTEGER; compile_eiffel: BOOLEAN)
		require
			has_32_bit_project: bit_count = 32 implies project_py_swapper.replacement_path.exists
		local
			build_command: EL_OS_COMMAND; scons_cmd: STRING
		do
			if bit_count = 32 then
				project_py_swapper.swap
			end
			scons_cmd := "scons action=finalize compile_eiffel=" + Yes_or_no [compile_eiffel]
			if compile_eiffel and then package.has_alternative_root_class then
				scons_cmd.append (" root_class=" + package.root_class_path.escaped)
			end
			create build_command.make (scons_cmd)
			build_command.execute

			has_build_error := build_command.has_error
			if bit_count = 32 then
				project_py_swapper.undo
			end
		end

feature {NONE} -- Implementation: attributes

	pecf_path: EL_FILE_PATH

	project_py_swapper: EL_FILE_SWAPPER

	package: WINZIP_SOFTWARE_PACKAGE

feature {NONE} -- Constants

	CPU_architecture: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<< [32, "x86"], [64, "x64"] >>)
		end

	Yes_or_no: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("no", "yes")
		end

end