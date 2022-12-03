note
	description: "[
		Maps command line arguments to the arguments of the make procedure of the `command' object
		conforming to `[$source EL_COMMAND]'. If no mapping errors occur during the initilization,
		the `run' procedure is called and executes the command.
	]"
	notes: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 11:56:11 GMT (Saturday 3rd December 2022)"
	revision: "51"

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

		The `command.make' routine must be exported to class [$source EL_COMMAND_CLIENT]
	]"
	descendants: "[
		**eiffel.ecf**
			EL_COMMAND_LINE_APPLICATION* [C -> EL_COMMAND]
				[$source UNDEFINE_PATTERN_COUNTER_APP]
				[$source PYXIS_TRANSLATION_TREE_COMPILER_APP]
				[$source PYXIS_ECF_CONVERTER_APP]
				[$source WINZIP_SOFTWARE_PACKAGE_BUILDER_APP]
				[$source CHECK_LOCALE_STRINGS_APP]
				[$source GITHUB_MANAGER_APP]
				[$source ENCODING_CHECK_APP]
				[$source FEATURE_EDITOR_APP]
				[$source ID3_FRAME_CODE_CLASS_GENERATOR_APP]
				[$source EL_LOGGED_COMMAND_LINE_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source CLASS_DESCENDANTS_APP]
					[$source LIBRARY_OVERRIDE_APP]
					[$source REPOSITORY_PUBLISHER_SUB_APPLICATION]* [C -> [$source REPOSITORY_PUBLISHER]]
						[$source REPOSITORY_SOURCE_LINK_EXPANDER_APP]
						[$source REPOSITORY_NOTE_LINK_CHECKER_APP]
						[$source EIFFEL_VIEW_APP]
						[$source IMP_CLASS_LOCATION_NORMALIZER_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_APPLICATION]* [C -> [$source EL_COMMAND]]
						[$source SOURCE_TREE_CLASS_RENAME_APP]
						[$source CODEC_GENERATOR_APP]
						[$source CODEBASE_STATISTICS_APP]
						[$source ECF_TO_PECF_APP]
						[$source FIND_AND_REPLACE_APP]
						[$source NOTE_EDITOR_APP]
							[$source NOTE_DATE_FIXER_APP]
						[$source SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP]*
							[$source UPGRADE_DEFAULT_POINTER_SYNTAX_APP]
				
		**toolkit.ecf**
			EL_COMMAND_LINE_APPLICATION* [C -> EL_COMMAND]
				[$source USER_AGENT_APP]
				[$source XML_TO_PYXIS_APP]
				[$source YOUTUBE_VIDEO_DOWNLOADER_APP]
				[$source EL_DEBIAN_PACKAGER_APP]
				[$source DUPLICITY_BACKUP_APP]
				[$source DUPLICITY_RESTORE_APP]
				[$source FILE_TREE_TRANSFORM_SCRIPT_APP]
				[$source PYXIS_TO_XML_APP]
				[$source EL_LOGGED_COMMAND_LINE_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source THUNDERBIRD_BOOK_EXPORTER_APP]
					[$source CAD_MODEL_SLICER_APP]
					[$source FILTER_INVALID_UTF_8_APP]
					[$source JOBSERVE_SEARCH_APP]
					[$source PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP]
					[$source LOCALIZATION_COMMAND_SHELL_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_APPLICATION]* [C -> [$source EL_COMMAND]]
						[$source THUNDERBIRD_WWW_EXPORTER_APP]
						[$source UNDATED_PHOTO_FINDER_APP]
						[$source VCF_CONTACT_SPLITTER_APP]
						[$source VCF_CONTACT_NAME_SWITCHER_APP]
						[$source FTP_BACKUP_APP]
						[$source FILE_MANIFEST_APP]
						[$source HTML_BODY_WORD_COUNTER_APP]
						[$source PYXIS_ENCRYPTER_APP]
						[$source PYXIS_TREE_TO_XML_COMPILER_APP]
						[$source TESTABLE_LOCALIZED_THUNDERBIRD_SUB_APPLICATION]* [READER -> [$source EL_ML_THUNDERBIRD_ACCOUNT_READER]]
							[$source LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP]
							[$source LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP]
				[$source EL_COMMAND_SHELL_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND_SHELL]]
					[$source CRYPTO_COMMAND_SHELL_APP]
	]"
end