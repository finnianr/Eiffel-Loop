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
	date: "2020-10-21 13:39:10 GMT (Wednesday 21st October 2020)"
	revision: "2"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER

inherit
	EL_COMMAND

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_FILE_SYSTEM

	WINZIP_SOFTWARE_COMMON

	EL_STRING_8_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_pecf_path: EL_FILE_PATH; architectures, targets: STRING)
		require
			path_exits: a_pecf_path.exists
			valid_architectures: valid_architecture_list (architectures)
			valid_targets: valid_target_list (targets)
		local
			scanner: PYXIS_ECF_SCANNER
		do
			pecf_path := a_pecf_path
			create scanner.make (a_pecf_path)
			config := scanner.new_config
			create architecture_list.make (2)
			across architectures.split (',') as bit_count loop
				bit_count.item.left_adjust
				architecture_list.extend (bit_count.item.to_integer)
			end
			create target_list.make_with_csv (targets)
		end

feature -- Basic operations

	execute
		do
			if target_list.has (Target.exe) then
				if architecture_list.has (64) then
					increment_pecf_build
				end
			end
			if target_list.has (Target.installer) then
				across Locale.all_languages as lang loop
					build_installer (Locale.in (lang.item))
				end
			end
		end

feature {NONE} -- Implementation

	build_exe (bit_count: INTEGER)
		local
			compile_eiffel: BOOLEAN
		do
			compile_eiffel := bit_count /= 32
			if compile_eiffel then
				-- Excluded unwanted sub applications for windows
				swap_application_root ("dev", "windows")
			end
		end

	build_installer (a_locale: EL_DEFERRED_LOCALE_I)
		local
			command: WINZIP_CREATE_SELF_EXTRACT_COMMAND
		do
			config.update (a_locale)
			create command.make (config)
			command.execute
		end

	exe_path (bit_count: INTEGER): EL_FILE_PATH
		do
			Result := Exe_path_template #$ [platform_name (bit_count), config.exe_name]
		end

	increment_pecf_build
		local
			list: EL_SPLIT_STRING_8_LIST; source_text, line: STRING
			found: BOOLEAN; i, line_start, line_end: INTEGER
		do
			source_text := File_system.plain_text (pecf_path)
			create list.make (source_text, character_string_8 ('%N'))
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
				File_system.write_plain_text (pecf_path, source_text)
			end
		end

	platform_name (bit_count: INTEGER): STRING
		do
			inspect bit_count
				when 32 then
					Result := "windows"

				when 64 then
					Result := "win64"
			else
				create Result.make_empty
			end
		end

	swap_application_root (temp_extension, extension: STRING)
		local
			src_root: ZSTRING
		do
			src_root := "source/application_root.%S"
			File_system.rename_file (src_root #$ ['e'], src_root #$ [temp_extension])
			File_system.rename_file (src_root #$ [extension], src_root #$ ['e'])
		end

	yes_no (flag: BOOLEAN): STRING
		do
			if flag then
				Result := "yes"
			else
				Result := "no"
			end
		end

feature {NONE} -- Implementation: attributes

	architecture_list: ARRAYED_LIST [INTEGER]

	config: PACKAGE_BUILDER_CONFIG

	pecf_path: EL_FILE_PATH

	target_list: EL_STRING_8_LIST

feature {NONE} -- Constants

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

end