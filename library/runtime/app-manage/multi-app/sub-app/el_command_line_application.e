note
	description: "[
		Maps command line arguments to the arguments of the make procedure of the `command' object
		conforming to `${EL_COMMAND}'. If no mapping errors occur during the initilization,
		the `run' procedure is called and executes the command.
	]"
	notes: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 14:10:31 GMT (Tuesday 2nd April 2024)"
	revision: "61"

deferred class
	EL_COMMAND_LINE_APPLICATION [C -> EL_APPLICATION_COMMAND]

inherit
	EL_APPLICATION
		redefine
			read_command_options, options_help, print_help
		end

	EL_APPLICATION_CONSTANTS

	EL_COMMAND_CLIENT

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	initialize
			--
		do
		end

	read_command_options
		do
			make_command := default_make
			if attached make_operands as operands then
				across argument_list as list loop
					list.item.set_operands (operands, list.cursor_index + first_operand_offset)
					list.item.try_put_argument
				end
			end
			if not has_error and then attached new_command as cmd then
				make_command (cmd)
				cmd.error_check (Current)
				command := cmd
			end
		end

feature -- Access

	description: READABLE_STRING_GENERAL
		do
			Result := new_command.description
		end

feature -- Basic operations

	run
		do
			command.execute
		end

	print_help
		do
			make_command := default_make
			Precursor
		end

feature {NONE} -- Argument items

	config_argument (help_description: detachable READABLE_STRING_GENERAL): EL_COMMAND_ARGUMENT
		local
			l_description: READABLE_STRING_GENERAL
		do
			if attached help_description as text then
				l_description := text
			else
				l_description := "Configuration file path"
			end
			Result := required_argument (Standard_option.config, l_description, << file_must_exist >>)
		end

	optional_argument (
		word_option, help_description: READABLE_STRING_GENERAL; validations: like No_checks
	): EL_COMMAND_ARGUMENT
		do
			create Result.make (Current, word_option, help_description)
			if validations /= No_checks then
				Result.validation_table.merge_array (validations)
			end
		end

	required_argument (
		word_option, help_description: READABLE_STRING_GENERAL; validations: like No_checks
	): EL_COMMAND_ARGUMENT
		do
			create Result.make (Current, word_option, help_description)
			Result.set_required
			if validations /= No_checks then
				Result.validation_table.merge_array (validations)
			end
		end

feature {NONE} -- Validations

	at_least_n_characters (n: INTEGER): like No_checks.item
		local
			template: ZSTRING
		do
			template := "Must have at least %S characters"
			Result := [template #$ [n], agent is_valid_string (?, n)]
		end

	at_least_one_file_must_exist: like No_checks.item
		do
			Result := ["At least one matching file must exist", agent is_valid_path_or_wild_card]
		end

	directory_must_exist: like No_checks.item
		do
			Result := ["The directory must exist", agent is_valid_path]
		end

	file_must_exist: like No_checks.item
		do
			Result := ["The file must exist", agent is_valid_path]
		end

	within_range (a_range: INTEGER_INTERVAL): like No_checks.item
		local
			template: ZSTRING
		do
			template := "number must be within range %S to %S"
			Result := ["The %S " + template #$ [a_range.lower, a_range.upper], agent integer_in_range (?, a_range)]
		end

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		-- for use with when modifiying `argument_specs' in descendant
		do
			create Result.make_from_array (argument_specs)
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
			-- argument specifications
		deferred
		ensure
			valid_specs_count: Result.count <= make_operands.count
		end

	default_make: PROCEDURE [like command]
		-- make procedure with open target and default operands
		deferred
		ensure
			closed_except_for_target: Result.open_count = 1
			target_is_open: Result.target /= Current implies not Result.is_target_closed
		end

	first_operand_offset: INTEGER
		do
			Result := make_command.is_target_closed.to_integer
		end

	integer_in_range (n: INTEGER; range: INTEGER_INTERVAL): BOOLEAN
		do
			Result := range.has (n)
		end

	is_valid_path (path: EL_PATH; is_optional: BOOLEAN): BOOLEAN
		do
			if is_optional then
				Result := not path.is_empty implies path.exists
			else
				Result := path.exists
			end
		end

	is_valid_path_or_wild_card (path: FILE_PATH; is_optional: BOOLEAN): BOOLEAN
		local
			parent_dir: DIR_PATH
		do
			if path.is_pattern then
				parent_dir := path.parent
				if parent_dir.is_empty then
					parent_dir := Directory.current_working
				end
				if parent_dir.exists then
					Result := across OS.file_list (parent_dir, path.base) as file some file.item.exists end
				end
			else
				Result := is_valid_path (path, is_optional)
			end
		end

	is_valid_string (str: READABLE_STRING_GENERAL; minimum_count: INTEGER): BOOLEAN
		do
			Result := str.count >= minimum_count
		end

	make_operands: TUPLE
		-- closed operands of `make_command'
		local
			procedure: EL_PROCEDURE
		do
			create procedure.make (make_command)
			Result := procedure.closed_operands
		end

	new_command: like command
		do
			if attached {like command} Eiffel.new_object ({like command}) as cmd then
				Result := cmd
			end
		end

	options_help: EL_APPLICATION_HELP_LIST
		require else
			make_command_attached: attached make_command
		local
			i: INTEGER
		do
			Result := Precursor
			-- Add command line options
			if attached make_operands as operands then
				across argument_list as list loop
					i := list.cursor_index + first_operand_offset
					Result.extend (list.item.word_option, list.item.help_description, operands [i])
				end
			end
		end

feature {NONE} -- Internal attributes

	command: C

	make_command: PROCEDURE [like command]

feature {NONE} -- Constants

	No_checks: ARRAY [TUPLE [key: READABLE_STRING_GENERAL; value: PREDICATE]]
		once
			create Result.make_empty
		end

note
	notes: "[
		Implementing `argument_specs' specifies command option names, a description that becomes part
		of the help text, and validation procedures and associated descriptions.

		Implementing `default_make' provides default arguments for initializing the command, which can
		then be overridden by the command line options specified in `argument_specs'.

		The `command.make' routine must be exported to class ${EL_COMMAND_CLIENT}
	]"
	descendants: "[
		**eiffel.ecf**
			EL_COMMAND_LINE_APPLICATION* [C -> ${EL_APPLICATION_COMMAND}]
				${LIBRARY_OVERRIDE_APP}
				${COMPILE_DESKTOP_PROJECTS_APP}
				${GITHUB_MANAGER_APP}
				${ECF_TO_PECF_APP}
				${PYXIS_TRANSLATION_TREE_COMPILER_APP}
				${PYXIS_ECF_CONVERTER_APP}
				${WINZIP_SOFTWARE_PACKAGE_BUILDER_APP}
				${CHECK_LOCALE_STRINGS_APP}
				${FEATURE_EDITOR_APP}
				${OPEN_GREP_RESULT_APP}
				${ZCODEC_GENERATOR_APP}
				${ID3_FRAME_CODE_CLASS_GENERATOR_APP}
				${SOURCE_MANIFEST_APPLICATION* [COMMAND -> SOURCE_MANIFEST_COMMAND]}
					${LIBRARY_MIGRATION_APP}
					${UPGRADE_DEFAULT_POINTER_SYNTAX_APP}
					${UPGRADE_LOG_FILTERS_APP}
					${UPGRADE_TEST_SET_CALL_BACK_CODE_APP}
					${UNDEFINE_PATTERN_COUNTER_APP}
					${CODE_METRICS_APP}
					${FIND_PATTERN_APP}
					${ENCODING_CHECK_APP}
					${REGULAR_EXPRESSION_SEARCH_APP}
					${CLASS_RENAMING_APP}
					${FIND_AND_REPLACE_APP}
					${NOTE_EDITOR_APP}
						${NOTE_DATE_FIXER_APP}
					${SOURCE_FILE_NAME_NORMALIZER_APP}
					${SOURCE_LEADING_SPACE_CLEANER_APP}
					${SOURCE_LOG_LINE_REMOVER_APP}
				${REPOSITORY_PUBLISHER_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
					${EIFFEL_VIEW_APP}
					${IMP_CLASS_LOCATION_NORMALIZER_APP}
					${REPOSITORY_SOURCE_LINK_EXPANDER_APP}
					${REPOSITORY_NOTE_LINK_CHECKER_APP}
				${CLASS_DESCENDANTS_APP}
				
		**toolkit.ecf**

			EL_COMMAND_LINE_APPLICATION* [C -> ${EL_APPLICATION_COMMAND}]
				${PYXIS_TREE_TO_XML_COMPILER_APP}
				${CAMERA_TRANSFER_APP}
				${SLIDE_SHOW_APP}
				${STOCK_CONSUMPTION_CALCULATOR_APP}
				${UNDATED_PHOTO_FINDER_APP}
				${USER_AGENT_APP}
				${XML_TO_PYXIS_APP}
				${YOUTUBE_VIDEO_DOWNLOADER_APP}
				${EL_DEBIAN_PACKAGER_APP}
				${DUPLICITY_BACKUP_APP}
				${DUPLICITY_RESTORE_APP}
				${FILE_SYNC_APP}
				${FILE_TREE_TRANSFORM_SCRIPT_APP}
				${FTP_BACKUP_APP}
				${FILE_MANIFEST_APP}
				${CURRENCY_EXCHANGE_HISTORY_APP}
				${HTML_BODY_WORD_COUNTER_APP}
				${JPEG_FILE_TIME_STAMPER_APP}
				${PNG_LINK_GENERATOR_APP}
				${PYXIS_ENCRYPTER_APP}
				${PYXIS_TO_XML_APP}
				${EL_LOGGED_COMMAND_LINE_APPLICATION* [C -> EL_APPLICATION_COMMAND]}
					${LOCALIZATION_COMMAND_SHELL_APP}
					${CAD_MODEL_SLICER_APP}
					${FILTER_INVALID_UTF_8_APP}
					${PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP}
				${THUNDERBIRD_ACCOUNT_READER_APP* [C -> TB_ACCOUNT_READER create make_from_file end]}
					${LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP}
					${LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP}
					${THUNDERBIRD_BOOK_EXPORTER_APP}
					${THUNDERBIRD_WWW_EXPORTER_APP}
				${VCF_CONTACT_NAME_APPLICATION*}
					${VCF_CONTACT_SPLITTER_APP}
					${VCF_CONTACT_NAME_SWITCHER_APP}
				${EL_COMMAND_SHELL_APPLICATION* [C -> EL_APPLICATION_COMMAND_SHELL]}
					${CRYPTO_COMMAND_SHELL_APP}
				${WEBSITE_MONITOR_APP}
	]"
end