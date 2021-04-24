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
	date: "2021-04-24 16:50:45 GMT (Saturday 24th April 2021)"
	revision: "11"

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

	EL_FILE_OPEN_ROUTINES

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_pecf_path: EL_FILE_PATH; architectures, targets, languages: STRING; a_output_dir: EL_DIR_PATH)
		require
			path_exits: a_pecf_path.exists
			root_class_exists: root_class_exists (a_pecf_path)
			valid_architectures: valid_architecture_list (architectures)
			valid_targets: valid_target_list (targets)
			valid_languages: valid_language_list (languages)
		local
			scanner: PYXIS_ECF_SCANNER
		do
			pecf_path := a_pecf_path
			if a_output_dir.is_absolute then
				output_dir := a_output_dir
			else
				output_dir := Directory.current_working.joined_dir_path (a_output_dir)
			end
			create scanner.make (a_pecf_path)
			config := scanner.new_config

			create architecture_list.make (2)
			across architectures.split (',') as bit_count loop
				bit_count.item.left_adjust
				architecture_list.extend (bit_count.item.to_integer)
			end
			architecture_list.reverse_sort
			create target_list.make_with_csv (targets)
			create language_list.make_with_csv (languages)
			create project_py_swapper.make ("project.py", "py32")
		end

feature -- Status query

	has_build_error: BOOLEAN

feature -- Basic operations

	execute
		do
			lio.put_path_field ("Output", output_dir)
			lio.put_new_line
			if output_dir.exists then
				lio.put_path_field ("Project", pecf_path)
				lio.put_new_line
				if architecture_list.has (64) then
					increment_pecf_build
				end
				if architecture_list.count > 0 then
					config.pass_phrase.share (User_input.line ("Signing pass phrase"))
					lio.put_new_line
				end
				across architecture_list as bit_count until has_build_error loop
					if target_list.has (Target.exe) then
						if bit_count.item = 32 implies project_py_swapper.replacement_path.exists then
							build_exe (bit_count.item, bit_count.item = 64)
							if not has_build_error then
								sha_256_sign (target_exe_path (bit_count.item))
							end
						else
							lio.put_labeled_string (project_py_swapper.replacement_path, " is missing")
							lio.put_new_line
							has_build_error := True
						end
					end
					if target_list.has (Target.installer) and then not has_build_error then
						if not output_dir.exists then
							File_system.make_directory (output_dir)
						end
						across language_list as lang loop
							build_installer (Locale.in (lang.item), bit_count.item)
						end
					end
				end
			else
				lio.put_line ("Path not found")
			end
		end

feature {NONE} -- Implementation

	build_exe (bit_count: INTEGER; compile_eiffel: BOOLEAN)
		require
			has_32_bit_project: bit_count = 32 implies project_py_swapper.replacement_path.exists
		local
			build_command: EL_OS_COMMAND; root_swapper: EL_FILE_SWAPPER
		do
			create root_swapper.make (Root_class_path, "windows")
			if bit_count = 32 then
				project_py_swapper.swap
			end
			if compile_eiffel then
				-- Swap root with another root containing limited set of sub-applications
				root_swapper.swap
			end
			create build_command.make ("scons action=finalize compile_eiffel=" + Yes_or_no [compile_eiffel])
			build_command.execute

			has_build_error := build_command.has_error
			if compile_eiffel then
				-- swap files back
				root_swapper.undo
			end
			if bit_count = 32 then
				project_py_swapper.undo
			end
		end

	build_installer (a_locale: EL_DEFERRED_LOCALE_I; bit_count: INTEGER)
		local
			command: WINZIP_CREATE_SELF_EXTRACT_COMMAND; zip_path: EL_FILE_PATH
		do
			build_zip_archive (a_locale.language, bit_count)

			if not has_build_error then
				zip_path := zip_archive_path (a_locale.language, bit_count)
				config.set_zip_archive_path (zip_path)
				config.update (a_locale)
				create command.make (config)
				command.execute
				File_system.remove_file (zip_path)
				sha_256_sign (installer_exe_path (a_locale.language, bit_count))
			end
		end

	build_zip_archive (language: STRING; bit_count: INTEGER)
		local
			zip_cmd: EL_OS_COMMAND
		do
			create zip_cmd.make ("wzzip -a -rP $zip_path package\*")
			zip_cmd.put_path ("zip_path", zip_archive_path (language, bit_count))
			zip_cmd.set_working_directory ("build/" + ISE_platform [bit_count])
			zip_cmd.execute
			has_build_error := zip_cmd.has_error
		end

	increment_pecf_build
		local
			list: EL_SPLIT_STRING_8_LIST; source_text, line: STRING
			found: BOOLEAN; i, line_start, line_end: INTEGER; s: EL_STRING_8_ROUTINES
		do
			source_text := File_system.plain_text (pecf_path)
			create list.make (source_text, s.character_string ('%N'))
			from list.start until list.after or found loop
				line := list.item (False)
				if line.has ('=') and then line.has_substring ("major")
					and then line.has_substring ("build")
				then
					line := line.twin
					line_start := list.item_start_index
					line_end := list.item_end_index
					found := True
				end
				list.forth
			end
			if found then
				from i := line.count until i = 1 or not line.item (i).is_digit loop
					i := i - 1
				end
				config.increment_build
				line.replace_substring (config.build.out, i + 1, line.count)
				source_text.replace_substring (line, line_start, line_end)
				lio.put_natural_field (pecf_path.base + " build", config.build)
				lio.put_new_line
				File_system.write_plain_text (pecf_path, source_text)
				write_ecf (source_text)
			end
		end

	installer_exe_path (language: STRING; bit_count: INTEGER): EL_FILE_PATH
		local
			inserts: TUPLE
		do
			inspect config.package_name_template.occurrences ('%S')
				when 2 then
					inserts := [bit_count, config.version.string]
			else
				inserts := [language, bit_count, config.version.string]
			end
			Result := output_dir + (config.package_name_template #$ inserts)
		end

	sha_256_sign (exe_path: EL_FILE_PATH)
		local
			sign_cmd: EL_OS_COMMAND
		do
			create sign_cmd.make ("[
				signtool sign
					/f $signing_certificate_path /p "$pass_phrase"
					/fd sha256 /tr $time_stamp_url/?td=sha256 /td sha256 /as /v $exe_path
			]")
			config.set_exe_path (exe_path)
			sign_cmd.set_working_directory (config.signtool_dir)
			sign_cmd.put_object (config)
			sign_cmd.execute
			if sign_cmd.has_error then
				has_build_error := True
				lio.put_line ("ERROR: signing")
				across sign_cmd.errors as line loop
					lio.put_line (line.item)
				end
			end
		end

	target_exe_path (bit_count: INTEGER): EL_FILE_PATH
		do
			Result := Exe_path_template #$ [ISE_platform [bit_count], config.exe_name]
			Result := Directory.current_working + Result
		end

	write_ecf (source_text: STRING)
		local
			ecf_generator: ECF_XML_GENERATOR
		do
			if attached open (pecf_path.with_new_extension ("ecf"), Write) as ecf_out then
				create ecf_generator.make
				ecf_generator.convert_text (source_text, ecf_out)
				ecf_out.close
			end
		end

	zip_archive_path (language: STRING; bit_count: INTEGER): EL_FILE_PATH
		do
			Result := installer_exe_path (language, bit_count).with_new_extension ("zip")
		end

feature {NONE} -- Implementation: attributes

	architecture_list: EL_SORTABLE_ARRAYED_LIST [INTEGER]

	config: PACKAGE_BUILDER_CONFIG

	language_list: EL_STRING_8_LIST

	output_dir: EL_DIR_PATH

	pecf_path: EL_FILE_PATH

	project_py_swapper: EL_FILE_SWAPPER

	target_list: EL_STRING_8_LIST

feature {NONE} -- Constants

	CPU_architecture: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<< [32, "x86"], [64, "x64"] >>)
		end

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

	ISE_platform: EL_HASH_TABLE [STRING, INTEGER]
		do
			create Result.make (<< [32, "windows"], [64, "win64"] >>)
		end

	Yes_or_no: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("no", "yes")
		end

end