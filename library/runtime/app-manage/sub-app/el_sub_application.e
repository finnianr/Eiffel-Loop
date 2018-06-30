note
	description: "Sub-application for a root class conforming to [$source EL_MULTI_APPLICATION_ROOT]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-28 13:02:59 GMT (Thursday 28th June 2018)"
	revision: "18"

deferred class
	EL_SUB_APPLICATION

inherit
	EL_MODULE_BUILD_INFO

	EL_MODULE_EXCEPTIONS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_ZSTRING

	EL_MODULE_LIO

feature {EL_SUB_APPLICATION_LIST} -- Initiliazation

	initialize
			--
		deferred
		end

	init_logging
		do
			Console.show_all (visible_types)
		end

	make
			--
		local
			boolean: BOOLEAN_REF
		do
			create options_help.make (11)
			create argument_errors.make (0)
			Exceptions.catch (Exceptions.Signal_exception)

			create boolean
			across standard_options as option loop
				set_boolean_from_command_opt (boolean, option.key, option.item)
			end
			init_logging
			if not (Args.has_no_app_header or Args.has_silent) then
				io_put_header
			end
			do_application
		end

feature -- Access

	argument_errors: ARRAYED_LIST [EL_COMMAND_ARGUMENT_ERROR]

	description: READABLE_STRING_GENERAL
		deferred
		end

	option_name: READABLE_STRING_GENERAL
			-- Command option name
		do
			Result := generator.as_lower
		end

	options_help: EL_SUB_APPLICATION_HELP_LIST

	unwrapped_description: ZSTRING
	 -- description unwrapped as a single line
		do
			create Result.make_from_general (description)
			Result.replace_character ('%N', ' ')
		end

feature -- Basic operations

	run
			--
		deferred
		end

feature -- Status query

	ask_user_to_quit: BOOLEAN
			--
		do
			Result := Args.word_option_exists ({EL_COMMAND_OPTIONS}.Ask_user_to_quit)
		end

	command_line_help_option_exists: BOOLEAN
		do
			-- Args.character_option_exists ({EL_COMMAND_OPTIONS}.Help [1]) or else
			-- This doesn't work because of a bug in {ARGUMENTS_32}.option_character_equal
			Result := Args.word_option_exists ({EL_COMMAND_OPTIONS}.Help)
		end

	has_argument_errors: BOOLEAN
		do
			Result := not argument_errors.is_empty
		end

	is_same_option (name: ZSTRING): BOOLEAN
		do
			Result := name.same_string (option_name)
		end

feature -- Element change

	set_app_configuration_option_name (a_name: READABLE_STRING_GENERAL)
			-- set once attribute 'Application_sub_option' in class EL_APPLICATION_CONFIG_CELL
		local
			config_cell: EL_APPLICATION_CONFIG_CELL [EL_FILE_PERSISTENT_IMP]
		do
			create config_cell.make_from_option_name (a_name)
		end

	set_attribute_from_command_opt (a_attribute: ANY; a_word_option, a_description: READABLE_STRING_GENERAL)
		do
			set_from_command_opt (a_attribute, a_word_option, a_description, False)
		end

	set_boolean_from_command_opt (a_bool: BOOLEAN_REF; a_word_option, a_description: READABLE_STRING_GENERAL)
		do
			if a_bool.item and then Args.word_option_exists (a_word_option) then
				a_bool.set_item (False)
			else
				a_bool.set_item (Args.word_option_exists (a_word_option))
			end
			options_help.extend (a_word_option, a_description, False)
		end

	set_from_command_opt (
		a_attribute: ANY; a_word_option, a_description: READABLE_STRING_GENERAL; is_required: BOOLEAN
	)
			-- set class attribute from command line option
		local
			l_argument_index: INTEGER; l_argument: ZSTRING
			argument_error: like new_argument_error
		do
			argument_error := new_argument_error (a_word_option)
			options_help.extend (a_word_option, a_description, a_attribute)
			if Args.has_value (a_word_option) then
				l_argument_index := Args.index_of_word_option (a_word_option) + 1
				l_argument := Args.item (l_argument_index)

				if attached {ZSTRING} a_attribute as a_string then
					a_string.share (l_argument)

				elseif attached {EL_DIR_PATH} a_attribute as a_dir_path then
					a_dir_path.set_path (l_argument)
					if not a_dir_path.exists then
						argument_errors.extend (argument_error)
						argument_errors.last.set_path_error (Eng_directory, a_dir_path)
					end

				elseif attached {EL_FILE_PATH} a_attribute as a_file_path then
					a_file_path.set_path (l_argument)
					if not a_file_path.exists then
						argument_errors.extend (argument_error)
						argument_errors.last.set_path_error (Eng_file, a_file_path)
					end

				elseif attached {REAL_REF} a_attribute as a_real_value then
					if l_argument.is_real then
						a_real_value.set_item (l_argument.to_real)
					else
						argument_errors.extend (argument_error)
						argument_errors.last.set_type_error ("real number")
					end

				elseif attached {INTEGER_REF} a_attribute as a_integer_value then
					if l_argument.is_integer then
						a_integer_value.set_item (l_argument.to_integer)
					else
						argument_errors.extend (argument_error)
						argument_errors.last.set_type_error ("integer")
					end
				elseif attached {BOOLEAN_REF} a_attribute as a_boolean_value then
					a_boolean_value.set_item (Args.word_option_exists (a_word_option))

				elseif attached {EL_ZSTRING_HASH_TABLE [STRING]} a_attribute as hash_table then
					hash_table [Zstring.as_zstring (a_word_option)] := l_argument
				end
			else
				if is_required then
					argument_errors.extend (argument_error)
					argument_errors.last.set_required_error
				end
			end
		end

	set_required_attribute_from_command_opt (a_attribute: ANY; a_word_option, a_description: READABLE_STRING_GENERAL)
		do
			set_from_command_opt (a_attribute, a_word_option, a_description, True)
		end

feature {NONE} -- Implementation

	call (object: ANY)
			-- For initializing once routines
		do
		end

	do_application
		do
			if ctrl_c_pressed then
				on_operating_system_signal
			else
				across Data_directories as dir loop
					if not dir.item.exists then
						File_system.make_directory (dir.item)
					end
				end
				initialize
				if command_line_help_option_exists then
					options_help.print_to_lio

				elseif has_argument_errors then
					argument_errors.do_all (agent {like argument_errors.item}.print_to_lio)
				else
					run
					if Ask_user_to_quit then
						lio.put_new_line
						io.put_string ("<RETURN TO QUIT>")
						io.read_character
					end
				end
			end
		rescue
			if Exceptions.is_signal then
				ctrl_c_pressed := True
				retry
			end
		end

	io_put_header
		local
			build_version, test: STRING
		do
			lio.put_new_line
			test := "test"
			if Args.argument_count >= 2 and then Args.item (2).same_string (test) then
				build_version := test
			else
				build_version := Build_info.version.out
			end
			lio.put_labeled_string ("Executable", Execution.executable_path.base)
			lio.put_labeled_string (" Version", build_version)
			lio.put_new_line

			lio.put_labeled_string ("Class", generator)
			lio.put_labeled_string (" Option", option_name)
			lio.put_new_line
			lio.put_string_field ("Description", description)
			lio.put_new_line_X2
		end

	new_option_name: ZSTRING
		do
			create Result.make_from_general (option_name)
		end

	on_operating_system_signal
			--
		do
		end

	standard_options: EL_HASH_TABLE [STRING, STRING]
		-- Standard command line options
		do
			create Result.make (<<
				[{EL_COMMAND_OPTIONS}.No_highlighting, 	"Turn off color highlighting for console output"],
				[{EL_COMMAND_OPTIONS}.No_app_header, 		"Suppress output of application information"],
				[{EL_COMMAND_OPTIONS}.silent, 				"Suppress all output to console"],
				[{EL_COMMAND_OPTIONS}.Ask_user_to_quit, 	"Prompt user to quit before exiting application"]
			>>)
		end

	visible_types: ARRAY [TYPE [EL_MODULE_LIO]]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result.make_empty
		end

feature {NONE} -- Internal attributes

	ctrl_c_pressed: BOOLEAN

feature {NONE} -- Factory routines

	new_argument_error (option: READABLE_STRING_GENERAL): EL_COMMAND_ARGUMENT_ERROR
		do
			create Result.make (option)
		end

feature -- Constants

	Eng_directory: ZSTRING
		once
			Result := "directory"
		end

	Eng_file: ZSTRING
		once
			Result := "file"
		end

feature {EL_DESKTOP_ENVIRONMENT_I} -- Constants

	Input_path_option_name: STRING
			--
		once
			Result := "file"
		end

	Template_command_error: ZSTRING
		once
			Result := "[
				Command "#" failed!
			]"
		end

	Data_directories: ARRAY [EL_DIR_PATH]
		once
			Result := << Directory.App_data, Directory.App_configuration >>
		end

note
	descendants: "[
		**eiffel.ecf**
			EL_SUB_APPLICATION*
				[$source EL_COMMAND_LINE_SUB_APPLICATION]*
					[$source LIBRARY_OVERRIDE_APP]
					[$source CHECK_LOCALE_STRINGS_APP]
					[$source ENCODING_CHECK_APP]
					[$source UNDEFINE_PATTERN_COUNTER_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]*
						[$source CODEC_GENERATOR_APP]
						[$source CODEBASE_STATISTICS_APP]
						[$source ECF_TO_PECF_APP]
						[$source FEATURE_EDITOR_APP]
						[$source FIND_AND_REPLACE_APP]
						[$source NOTE_EDITOR_APP]
						[$source SOURCE_TREE_CLASS_RENAME_APP]
						[$source SOURCE_TREE_EDIT_COMMAND_LINE_SUB_APP]*
							[$source UPGRADE_DEFAULT_POINTER_SYNTAX_APP]
					[$source REPOSITORY_PUBLISHER_SUB_APPLICATION]*
						[$source REPOSITORY_PUBLISHER_APP]
						[$source REPOSITORY_SOURCE_LINK_EXPANDER_APP]
						[$source REPOSITORY_NOTE_LINK_CHECKER_APP]
					[$source CLASS_DESCENDANTS_APP]
				[$source EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION]*
					[$source AUTOTEST_DEVELOPMENT_APP]
				[$source EL_REGRESSION_TESTABLE_SUB_APPLICATION]*
					[$source CODE_HIGHLIGHTING_TEST_APP]
					[$source SOURCE_TREE_EDIT_SUB_APP]*
						[$source CLASS_PREFIX_REMOVAL_APP]
						[$source UPGRADE_LOG_FILTERS_APP]
						[$source SOURCE_FILE_NAME_NORMALIZER_APP]
						[$source SOURCE_LOG_LINE_REMOVER_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]*
				[$source EL_VERSION_APP]
				[$source EL_INSTALLER_SUB_APPLICATION]*
				
		**toolkit.ecf**
			EL_SUB_APPLICATION*
				[$source EL_REGRESSION_TESTABLE_SUB_APPLICATION]*
					[$source JOBSERVE_SEARCH_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]*
						[$source UNDATED_PHOTOS_APP]
						[$source HTML_BODY_WORD_COUNTER_APP]
						[$source PYXIS_ENCRYPTER_APP]
						[$source PYXIS_TREE_TO_XML_COMPILER_APP]
						[$source VCF_CONTACT_SPLITTER_APP]
						[$source VCF_CONTACT_NAME_SWITCHER_APP]
						[$source XML_TO_PYXIS_APP]
						[$source PYXIS_TO_XML_APP]
						[$source PYXIS_TRANSLATION_TREE_COMPILER_APP]
						[$source THUNDERBIRD_WWW_EXPORTER_APP]
						[$source THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP]
						[$source FTP_BACKUP_APP]
				[$source EL_VERSION_APP]
				[$source EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION]*
					[$source AUTOTEST_DEVELOPMENT_APP]
				[$source EL_INSTALLER_SUB_APPLICATION]*
				[$source EL_COMMAND_LINE_SUB_APPLICATION]*
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]*
					[$source LOCALIZATION_COMMAND_SHELL_APP]
					[$source PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP]
					[$source FILTER_INVALID_UTF_8_APP]
					[$source YOUTUBE_HD_DOWNLOAD_APP]
					[$source EL_COMMAND_SHELL_SUB_APPLICATION]*
						[$source CRYPTO_APP]
						
		**manage-mp3.ecf**
			EL_SUB_APPLICATION*
				[$source EL_VERSION_APP]
				[$source EL_REGRESSION_TESTABLE_SUB_APPLICATION]*
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]*
						[$source RHYTHMBOX_MUSIC_MANAGER_APP]
						[$source ID3_EDITOR_APP]
						[$source TANGO_MP3_FILE_COLLATOR_APP]
					[$source RBOX_APPLICATION]*
						[$source RBOX_IMPORT_NEW_MP3_APP]
						[$source RBOX_PLAYLIST_IMPORT_APP]
						[$source RBOX_DATABASE_TRANSFORM_APP]*
							[$source RBOX_RESTORE_PLAYLISTS_APP]
				[$source EL_INSTALLER_SUB_APPLICATION]*
				[$source EL_COMMAND_LINE_SUB_APPLICATION]*
					[$source MP3_AUDIO_SIGNATURE_READER_APP]
					[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]*
	]"
end
