note
	description: "Winzip self-extracting package builder implementing [$source EL_COMMAND]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-19 15:17:33 GMT (Monday 19th June 2023)"
	revision: "25"

class
	WINZIP_SOFTWARE_PACKAGE

inherit
	EL_APPLICATION_COMMAND
		rename
			execute as build
		undefine
			is_equal
		end

	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			element_node_fields as Empty_set
		export
			{WINZIP_CREATE_SELF_EXTRACT_COMMAND} field_table
		redefine
			make_default
		end

	EL_EVENT_LISTENER
		rename
			notify as notify_error
		undefine
			is_equal
		end

	WZIPSE32_ARGUMENTS undefine is_equal end

	EL_MODULE_DIRECTORY

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config_path: FILE_PATH)
			--
		require
			config_exists: a_config_path.exists
		do
			make_from_file (a_config_path)
			name_template.replace_substring_all ("%%S", "%S")

			create project_config.make_scons (project_py)
			bit_count := 64
			if not output_dir.is_absolute then
				output_dir := Directory.current_working #+ output_dir
			end
		end

	make_default
		do
			Precursor
			create architecture_list.make (2)
			create language_list.make (2)
			create project_py.make
		end

feature -- Constants

	Description: STRING = "Build a software package as a self-extracting WinZip exe"

feature -- Basic operations

	build
		local
			reverse_list: EL_SORTABLE_ARRAYED_LIST [INTEGER]; is_valid: BOOLEAN_REF
		do
			create is_valid
			check_validity (is_valid)
			if is_valid.item then
				lio.put_path_field ("Output %S", output_dir)
				lio.put_new_line
				lio.put_path_field ("Project", project_config.pyxis_ecf_path)
				lio.put_new_line
				if architecture_list.count > 0 then
					if build_exe and architecture_list.has (64) then
						project_config.bump_build
					end
					sign_tool.pass_phrase.share (User_input.line ("Signing pass phrase"))
					lio.put_new_line
				end
				has_build_error := False
				create reverse_list.make_from_array (architecture_list.to_array)
				reverse_list.reverse_sort
				across reverse_list as count until has_build_error loop
					bit_count := count.item
					if build_exe then
						if bit_count = 32 implies project_py.has_32_bit then
							build_executable
						else
							lio.put_labeled_string (project_py.project_32_path, " is missing")
							lio.put_new_line
							has_build_error := True
						end
					end
					if build_installers and then not has_build_error then
						sign_tool.exe_path.share (Directory.current_working + relative_exe_path)
						sign_tool.sign_exe (Current)
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

	build_executable
		require
			has_32_bit_project: bit_count = 32 implies project_py.has_32_bit
		local
			build_command: EL_OS_COMMAND
		do
			if bit_count = 32 then
				project_py.change_to_32
			end
			create build_command.make (scons_cmd)
			build_command.execute

			has_build_error := build_command.has_error
			if bit_count = 32 then
				project_py.revert_to_64
			end
		end

	build_installer (a_locale: EL_DEFERRED_LOCALE_I)
		local
			command: WINZIP_CREATE_SELF_EXTRACT_COMMAND; template: WINZIP_TEMPLATE_TEXTS
		do
			if not output_dir.exists then
				File_system.make_directory (output_dir)
			end
			sign_tool.exe_path.share (installer_exe_path (a_locale.language))
			zip_archive_path := sign_tool.exe_path.with_new_extension ("zip")
			build_zip_archive (a_locale)

			if not has_build_error then
				create template.make_with_locale (a_locale)
				text_dialog_message := template.installer_dialog_box #$ [project_config.system.product]
				text_install := template.unzip_installation #$ [project_config.system.product]
				title := template.installer_title #$ [project_config.system.product]

				if a_locale.language ~ "de" then
					language_option := "-lg" -- German
				else
					language_option := "-le" -- English
				end

				create command.make (Current)
				command.execute
				File_system.remove_file (zip_archive_path)
				sign_tool.sign_exe (Current)
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

	installer_exe_path (language: STRING): FILE_PATH
		local
			inserts: TUPLE; platform_dir: ZSTRING
		do
			if attached project_config.system.version as version then
				inspect name_template.occurrences ('%S')
					when 2 then
						inserts := [bit_count, version.string]
				else
					inserts := [language, bit_count, version.string]
				end
			end
			platform_dir := ISE_platform_table [bit_count]
			Result := output_dir.joined_file_steps (<< platform_dir, name_template #$ inserts >>)
		end

	ise_platform: STRING
		do
			Result := ISE_platform_table [bit_count]
		end

	languages: STRING
		do
			Result := language_list.comma_separated_string
		end

	relative_exe_path: FILE_PATH
		do
			Result := Exe_path_template #$ [ise_platform, project_config.executable_name_full]
		end

	notify_error
		do
			has_build_error := True
		end

	scons_cmd: STRING
		do
			Result := "scons action=finalize"
			if bit_count = 64 and then has_alternative_root_class then
				Result.append (" root_class=" + root_class_path.escaped)
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

	project_py: SCONS_PROJECT_PY_CONFIG
		-- Python config "project.py"

	project_config: PYXIS_EIFFEL_CONFIG
		-- Pyxis Eiffel configuration translateable to ecf XML

	sign_tool: SIGN_TOOL

feature {NONE} -- Constants

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

	ISE_platform_table: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<< [32, "windows"], [64, "win64"] >>)
		end

note
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

end