note
	description: "Winzip self-extracting package builder implementing [$source EL_COMMAND]"
	notes: "[
		**Configured by Pyxis file**

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			winzip_software_package:
				# wzipse32 arguments
				install_command = "package\\bin\\myching.exe -install -silent"
				package_ico = "resources/desktop-icons/package.ico"

				# signtool arguments
				signing_certificate_path = "$USERPROFILE/Documents/My-signing-cert.pfx"
				signtool_dir = "$MSDK/v8.1/signtool"
				time_stamp_url = "http://timestamp.comodoca.com"

				# build parameters
				output_dir = build; 	name_template = "MyChing-%S-win%S-%S.exe"
				root_class_path = "source/application_root.windows"
				build_exe = true; build_installers = true

				architecture_list:
					item:
						32
					item:
						64

				language_list:
					item:
						"en"
					item:
						"de"

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "13"

class
	WINZIP_SOFTWARE_PACKAGE

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			element_node_type as	Attribute_node
		export
			{WINZIP_CREATE_SELF_EXTRACT_COMMAND} field_table
		redefine
			make_default
		end

	EL_COMMAND
		rename
			execute as build
		undefine
			is_equal
		end

	SIGN_TOOL_ARGUMENTS undefine is_equal end

	WZIPSE32_ARGUMENTS undefine is_equal end

	PACKAGE_BUILD_CONSTANTS

	EL_MODULE_DIRECTORY

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config_path: FILE_PATH; a_pecf_path: FILE_PATH)
			--
		require
			config_exists: a_config_path.exists
			pecf_exists: a_pecf_path.exists
		do
			make_from_file (a_config_path)
			name_template.replace_substring_general_all ("%%S", "%S")

			create software.make (a_pecf_path)
			bit_count := 64
			if not output_dir.is_absolute then
				output_dir := Directory.current_working.joined_dir_path (output_dir)
			end
		end

	make_default
		do
			Precursor
			create architecture_list.make (2)
			create language_list.make (2)
			create project_py_swapper.make (Project_py, "py32")
		end

feature -- Basic operations

	build
		local
			reverse_list: EL_SORTABLE_ARRAYED_LIST [INTEGER]; is_valid: BOOLEAN_REF
		do
			create is_valid
			check_validity (is_valid)
			if is_valid.item then
				lio.put_path_field ("Output", output_dir)
				lio.put_new_line
				lio.put_path_field ("Project", software.pecf_path)
				lio.put_new_line
				if architecture_list.count > 0 then
					if build_exe and architecture_list.has (64) then
						software.increment_build
					end
					pass_phrase.share (User_input.line ("Signing pass phrase"))
					lio.put_new_line
				end
				has_build_error := False
				create reverse_list.make_from_array (architecture_list.to_array)
				reverse_list.reverse_sort
				across reverse_list as count until has_build_error loop
					bit_count := count.item
					if build_exe then
						if bit_count = 32 implies project_py_32_exists then
							build_executable
						else
							lio.put_labeled_string (project_py_swapper.replacement_path, " is missing")
							lio.put_new_line
							has_build_error := True
						end
					end
					if build_installers and then not has_build_error then
						exe_path := Directory.current_working + Exe_path_template #$ [ise_platform, software.exe_name]
						sha_256_sign
						across language_list as lang until has_build_error loop
							build_installer (Locale.in (lang.item))
						end
					end
				end
			end
		end

feature -- Status query

	has_alternative_root_class: BOOLEAN
		do
			Result := not root_class_path.is_empty
		end

	has_build_error: BOOLEAN

	project_py_32_exists: BOOLEAN
		do
			Result := project_py_swapper.replacement_path.exists
		end

	valid_architectures: BOOLEAN
		do
			Result := across architecture_list as n all (32 |..| 64).has (n.item) end
		end

	valid_languages: BOOLEAN
		do
			Result := across language_list as list all Locale.all_languages.has (list.item) end
		end

	valid_name_template: BOOLEAN
		do
			Result := name_template.ends_with_general (".exe") and then (2 |..| 3).has (name_template.occurrences ('%S'))
		end

feature {NONE} -- Implementation

	check_validity (is_valid: BOOLEAN_REF)
		do
			if not valid_architectures then
				lio.put_labeled_string ("Invalid architecture in list", architecture_list.comma_separated_string)
				lio.put_new_line
				lio.put_line ("Must be one of: 32 | 64")

			elseif not valid_languages then
				lio.put_labeled_string ("Invalid language in list", languages)
				lio.put_new_line

			elseif not output_dir.exists then
				lio.put_labeled_string ("Directory does not exist", output_dir.to_string)
				lio.put_new_line

			elseif has_alternative_root_class and then not root_class_path.exists then
				lio.put_labeled_string ("Root class does not exist", root_class_path.to_string)
				lio.put_new_line

			elseif not valid_name_template then
				lio.put_labeled_string ("Invalid name template", name_template)
				lio.put_new_line
			else
				is_valid.set_item (True)
			end
		end

	build_executable
		require
			has_32_bit_project: bit_count = 32 implies project_py_32_exists
		local
			build_command: EL_OS_COMMAND
		do
			if bit_count = 32 then
				project_py_swapper.swap
			end
			create build_command.make (scons_cmd)
			build_command.execute

			has_build_error := build_command.has_error
			if bit_count = 32 then
				project_py_swapper.undo
			end
		end

	build_installer (a_locale: EL_DEFERRED_LOCALE_I)
		local
			command: WINZIP_CREATE_SELF_EXTRACT_COMMAND; template: WINZIP_TEMPLATE_TEXTS
		do
			if not output_dir.exists then
				File_system.make_directory (output_dir)
			end
			exe_path := installer_exe_path (a_locale.language)
			zip_archive_path := exe_path.with_new_extension ("zip")
			build_zip_archive (a_locale)

			if not has_build_error then
				create template.make_with_locale (a_locale)
				text_dialog_message := template.installer_dialog_box #$ [software.product]
				text_install := template.unzip_installation #$ [software.product]
				title := template.installer_title #$ [software.product]

				if a_locale.language ~ "de" then
					language_option := "-lg" -- German
				else
					language_option := "-le" -- English
				end

				create command.make (Current)
				command.execute
				File_system.remove_file (zip_archive_path)
				sha_256_sign
			end
		end

	build_zip_archive (a_locale: EL_DEFERRED_LOCALE_I)
		-- build archive with path `zip_archive_path'
		local
			zip_cmd: EL_OS_COMMAND
		do
			create zip_cmd.make ("wzzip -a -rP $zip_archive_path package\*")
			zip_cmd.put_object (Current)
			zip_cmd.set_working_directory ("build/" + ise_platform)
			zip_cmd.execute
			has_build_error := zip_cmd.has_error
		end

	languages: STRING
		do
			Result := language_list.comma_separated_string
		end

	installer_exe_path (language: STRING): FILE_PATH
		local
			inserts: TUPLE; platform_dir: ZSTRING
		do
			inspect name_template.occurrences ('%S')
				when 2 then
					inserts := [bit_count, software.version.string]
			else
				inserts := [language, bit_count, software.version.string]
			end
			platform_dir := ISE_platform_table [bit_count]
			Result := output_dir.joined_file_steps (<< platform_dir, name_template #$ inserts >>)
		end

	ise_platform: STRING
		do
			Result := ISE_platform_table [bit_count]
		end

	scons_cmd: STRING
		do
			Result := "scons action=finalize"
			if bit_count = 64 and then has_alternative_root_class then
				Result.append (" root_class=" + root_class_path.escaped)
			end
		end

	sha_256_sign
		-- sign the file `exe_path'
		local
			sign_cmd: EL_OS_COMMAND
		do
			create sign_cmd.make ("[
				signtool sign
					/f $signing_certificate_path /p "$pass_phrase"
					/fd sha256 /tr $time_stamp_url/?td=sha256 /td sha256 /as /v $exe_path
			]")
			if not signtool_dir.is_empty then
				sign_cmd.set_working_directory (signtool_dir)
			end
			sign_cmd.put_object (Current)
			sign_cmd.execute
			if sign_cmd.has_error then
				has_build_error := True
				lio.put_line ("ERROR: signing")
				across sign_cmd.errors as line loop
					lio.put_line (line.item)
				end
			end
		end

feature {NONE} -- Configuration parameters

	architecture_list: EL_ARRAYED_LIST [INTEGER]

	build_exe: BOOLEAN

	build_installers: BOOLEAN

	language_list: EL_STRING_8_LIST

	name_template: ZSTRING

	output_dir: DIR_PATH

	root_class_path: FILE_PATH
		-- optional root class to be used instead of system default specified in ecf

feature {NONE} -- Implementation: attributes

	bit_count: INTEGER

	project_py_swapper: EL_FILE_SWAPPER

	software: SOFTWARE_INFO

end
