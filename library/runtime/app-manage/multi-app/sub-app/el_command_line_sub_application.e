note
	description: "[
		Maps command line arguments to the arguments of the make procedure of the `command' object
		conforming to `[$source EL_COMMAND]'. If no mapping errors occur during the initilization,
		the `run' procedure is called and executes the command.
	]"
	notes: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 13:01:35 GMT (Sunday 23rd January 2022)"
	revision: "32"

deferred class
	EL_COMMAND_LINE_SUB_APPLICATION [C -> EL_COMMAND]

inherit
	EL_SUB_APPLICATION
		export
			{EL_COMMAND_ARGUMENT} new_argument_error
		redefine
			read_command_options
		end

	EL_MAKE_PROCEDURE_INFO

	EL_COMMAND_CLIENT

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	initialize
			--
		do
			if attached new_command as cmd then
				make_command (cmd)
				command := cmd
			end
		end

	read_command_options
		do
			make_command := default_make
			set_closed_operands
		end

feature -- Access

	description: READABLE_STRING_GENERAL
		do
			Result := new_command.description
		end

feature -- Basic operations

	run
			--
		do
			command.execute
		end

feature {NONE} -- Implementation

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

	set_closed_operands
		-- set closed arguments of `make_command' from command line
		local
			procedure: EL_PROCEDURE; offset: INTEGER
		do
			create procedure.make (make_command)
			operands := procedure.closed_operands
			if operands.count > 0
				and then operands.is_reference_item (1)
				and then operands.reference_item (1) = Current
			then
				offset := 1
			end
			create specs.make_from_array (argument_specs)
			across specs as argument_spec loop
				argument_spec.item.set_operand (argument_spec.cursor_index + offset)
			end
		end

feature {NONE} -- Validations

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

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
			-- argument specifications
		deferred
		ensure
			valid_specs_count: Result.count <= operands.count
		end

	specs_list (array: ARRAY [like specs.item]): EL_ARRAYED_LIST [like specs.item]
		-- for use with `Precursor' when redefining `argument_specs'
		-- As in `specs_list (Precursor)'
		do
			create Result.make_from_array (array)
		end

	default_make: PROCEDURE [like command]
		-- make procedure with open target and default operands
		deferred
		ensure
			closed_except_for_target: Result.open_count = 1
			target_is_open: Result.target /= Current implies not Result.is_target_closed
		end

	is_valid_path (path: EL_PATH; is_optional: BOOLEAN): BOOLEAN
		do
			if is_optional then
				Result := not path.is_empty implies path.exists
			else
				Result := path.exists
			end
		end

	integer_in_range (n: INTEGER; range: INTEGER_INTERVAL): BOOLEAN
		do
			Result := range.has (n)
		end

	new_command: like command
		do
			if attached {like command} Eiffel.new_object ({like command}) as cmd then
				Result := cmd
			end
		end

feature {EL_COMMAND_ARGUMENT, EL_MAKE_OPERAND_SETTER} -- Internal attributes

	command: C

	make_command: PROCEDURE [like command]

	operands: TUPLE
		-- make procedure operands

	specs: ARRAYED_LIST [EL_COMMAND_ARGUMENT];

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
			EL_COMMAND_LINE_SUB_APPLICATION* [C -> EL_COMMAND]
				[$source UNDEFINE_PATTERN_COUNTER_APP]
				[$source PYXIS_TRANSLATION_TREE_COMPILER_APP]
				[$source PYXIS_ECF_CONVERTER_APP]
				[$source WINZIP_SOFTWARE_PACKAGE_BUILDER_APP]
				[$source CHECK_LOCALE_STRINGS_APP]
				[$source GITHUB_MANAGER_APP]
				[$source ENCODING_CHECK_APP]
				[$source FEATURE_EDITOR_APP]
				[$source ID3_FRAME_CODE_CLASS_GENERATOR_APP]
				[$source EL_LOGGED_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source CLASS_DESCENDANTS_APP]
					[$source LIBRARY_OVERRIDE_APP]
					[$source REPOSITORY_PUBLISHER_SUB_APPLICATION]* [C -> [$source REPOSITORY_PUBLISHER]]
						[$source REPOSITORY_SOURCE_LINK_EXPANDER_APP]
						[$source REPOSITORY_NOTE_LINK_CHECKER_APP]
						[$source EIFFEL_VIEW_APP]
						[$source IMP_CLASS_LOCATION_NORMALIZER_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
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
			EL_COMMAND_LINE_SUB_APPLICATION* [C -> EL_COMMAND]
				[$source USER_AGENT_APP]
				[$source XML_TO_PYXIS_APP]
				[$source YOUTUBE_VIDEO_DOWNLOADER_APP]
				[$source EL_DEBIAN_PACKAGER_APP]
				[$source DUPLICITY_BACKUP_APP]
				[$source DUPLICITY_RESTORE_APP]
				[$source FILE_TREE_TRANSFORM_SCRIPT_APP]
				[$source PYXIS_TO_XML_APP]
				[$source EL_LOGGED_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source THUNDERBIRD_BOOK_EXPORTER_APP]
					[$source CAD_MODEL_SLICER_APP]
					[$source FILTER_INVALID_UTF_8_APP]
					[$source JOBSERVE_SEARCH_APP]
					[$source PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP]
					[$source LOCALIZATION_COMMAND_SHELL_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
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
				[$source EL_COMMAND_SHELL_SUB_APPLICATION]* [C -> [$source EL_COMMAND_SHELL_COMMAND]]
					[$source CRYPTO_COMMAND_SHELL_APP]
	]"
end