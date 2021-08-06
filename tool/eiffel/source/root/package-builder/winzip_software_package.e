note
	description: "Winzip self-extracting package build configuration"
	notes: "[
		**Example**

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			winzip_software_package:
				output_dir = "$EIFFEL/myching-server/www/download"
				build_exe = true; build_installers = true
				root_class_path = "source/application_root.windows"

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
	date: "2021-08-06 16:47:55 GMT (Friday 6th August 2021)"
	revision: "6"

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

	EL_MODULE_DIRECTORY

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_software: SOFTWARE_INFO)
			--
		do
			software := a_software
			make_from_file (a_file_path)
			name_template.replace_substring_general_all ("%%S", "%S")
			if not output_dir.is_absolute then
				output_dir := Directory.current_working.joined_dir_path (output_dir)
			end
		end

	make_default
		do
			Precursor
			create architecture_list.make (2)
			create language_list.make (2)
		end

feature -- Conversion

	architectures: ZSTRING
		do
			Result := architecture_list.comma_separated_string
		end

	languages: STRING
		do
			Result := language_list.comma_separated_string
		end

feature -- Access

	architecture_list: EL_ARRAYED_LIST [INTEGER]

	installer_exe_path (language: STRING; bit_count: INTEGER): EL_FILE_PATH
		local
			inserts: TUPLE
		do
			inspect name_template.occurrences ('%S')
				when 2 then
					inserts := [bit_count, software.version.string]
			else
				inserts := [language, bit_count, software.version.string]
			end
			Result := output_dir + (name_template #$ inserts)
		end

	language_list: EL_STRING_8_LIST

	name_template: ZSTRING

	output_dir: EL_DIR_PATH

	root_class_path: EL_FILE_PATH

	software: SOFTWARE_INFO

feature -- wzipse32 arguments

	install_command: ZSTRING

	language_option: STRING
		-- '-lg' or '-le'

	package_ico: EL_FILE_PATH

	text_dialog_message: ZSTRING

	text_install: ZSTRING

	title: ZSTRING

	zip_archive_path: EL_FILE_PATH

feature -- sign tool arguments

	exe_path: EL_FILE_PATH

	pass_phrase: STRING

	signing_certificate_path: EL_FILE_PATH

	signtool_dir: EL_DIR_PATH

	time_stamp_url: STRING

feature -- Status query

	build_exe: BOOLEAN

	build_installers: BOOLEAN

	has_alternative_root_class: BOOLEAN
		do
			Result := not root_class_path.is_empty
		end

	has_build_error: BOOLEAN

	is_valid: BOOLEAN

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

feature -- Status change

	check_validity
		do
			if not valid_architectures then
				lio.put_labeled_string ("Invalid architecture in list", architectures)
				lio.put_new_line
				lio.put_line ("Must be one of: 32 | 64")
				is_valid := False

			elseif not valid_languages then
				lio.put_labeled_string ("Invalid language in list", languages)
				lio.put_new_line
				is_valid := False

			elseif not output_dir.exists then
				lio.put_labeled_string ("Directory does not exist", output_dir.to_string)
				lio.put_new_line
				is_valid := False

			elseif has_alternative_root_class and then not root_class_path.exists then
				lio.put_labeled_string ("Root class does not exist", root_class_path.to_string)
				lio.put_new_line
				is_valid := False
			elseif not valid_name_template then
				lio.put_labeled_string ("Invalid name template", name_template)
				lio.put_new_line
				is_valid := False
			else
				is_valid := True
			end
		end

feature -- Basic operations

	build_installer (a_locale: EL_DEFERRED_LOCALE_I; bit_count: INTEGER)
		local
			command: WINZIP_CREATE_SELF_EXTRACT_COMMAND; template: WINZIP_TEMPLATE_TEXTS
		do
			exe_path := installer_exe_path (a_locale.language, bit_count)
			zip_archive_path := exe_path.with_new_extension ("zip")
			build_zip_archive (a_locale, bit_count)

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
				sha_256_sign (bit_count)
			end
		end

	sha_256_sign_software_exe (bit_count: INTEGER)
		do
			exe_path := software.target_exe_path (ISE_platform [bit_count.item])
			sha_256_sign (bit_count)
		end

feature -- Element change

	set_pass_phrase (a_pass_phrase: STRING)
		do
			pass_phrase := a_pass_phrase
		end

feature {NONE} -- Implementation

	build_zip_archive (a_locale: EL_DEFERRED_LOCALE_I; bit_count: INTEGER)
		-- build archive with path `zip_archive_path'
		local
			zip_cmd: EL_OS_COMMAND
		do
			create zip_cmd.make ("wzzip -a -rP $zip_archive_path package\*")
			zip_cmd.put_object (Current)
			zip_cmd.set_working_directory ("build/" + ISE_platform [bit_count])
			zip_cmd.execute
			has_build_error := zip_cmd.has_error
		end

	sha_256_sign (bit_count: INTEGER)
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

feature {NONE} -- Constants

	ISE_platform: EL_HASH_TABLE [STRING, INTEGER]
		do
			create Result.make (<< [32, "windows"], [64, "win64"] >>)
		end

end