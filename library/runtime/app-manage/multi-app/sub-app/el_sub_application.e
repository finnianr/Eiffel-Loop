note
	description: "Sub-application for a root class conforming to [$source EL_MULTI_APPLICATION_ROOT]"
	notes: "[
		To create a localized sub-application redefine `new_locale' as follows:

			new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
				do
					create Result.make
				end

	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-25 14:51:30 GMT (Friday 25th June 2021)"
	revision: "47"

deferred class
	EL_SUB_APPLICATION

inherit
	ANY

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_BUILD_INFO
	EL_MODULE_EXCEPTION
	EL_MODULE_EXECUTABLE
	EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM
	EL_MODULE_LIO
	EL_MODULE_OS_RELEASE
	EL_MODULE_OS

	EL_SHARED_BASE_OPTION
	EL_SHARED_APPLICATION_OPTION

feature {EL_FACTORY_CLIENT} -- Initialization

	initialize
			--
		deferred
		end

	make
			--
		do
			make_solitary
			call (new_locale)
			-- Necessary to redefine `Build_info' as type `BUILD_INFO' if the project root class is `Current'
			call (Build_info)

			create options_help.make (11)
			create argument_errors.make (0)
			Exception.catch ({EXCEP_CONST}.Signal_exception)

			across standard_options as options loop
				across options.item.help_table as help loop
					options_help.extend (help.key, help.item.description, help.item.default_value)
				end
			end
			across App_directory_list as list loop
				if not list.item.exists then
					create_app_directory (list.item)
				end
			end
			init_console
			if not (Application_option.no_app_header or Base_option.silent) then
				io_put_header
			end
			do_application
		end

feature -- Access

	argument_errors: ARRAYED_LIST [EL_COMMAND_ARGUMENT_ERROR]

	default_option_name: STRING
		-- lower case generator with `_app' removed from tail
		do
			Result := generator
			Result.to_lower
			if Result.ends_with ("_app") then
				Result.remove_tail (4)
			end
		end

	description: READABLE_STRING_GENERAL
		deferred
		end

	exit_code: INTEGER

	option_name: READABLE_STRING_GENERAL
			-- Command option name
		do
			Result := default_option_name
		end

	options_help: EL_SUB_APPLICATION_HELP_LIST

	unwrapped_description: ZSTRING
	 -- description unwrapped as a single line
		do
			create Result.make_from_general (description)
			Result.replace_character ('%N', ' ')
		end

	user_config_dir: EL_DIR_PATH
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := Directory.App_configuration #+ s.as_zstring (option_name)
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
			Result := Application_option.ask_user_to_quit
		end

	has_argument_errors: BOOLEAN
		do
			Result := not argument_errors.is_empty
		end

	is_same_option (name: ZSTRING): BOOLEAN
		do
			Result := name.same_string (option_name)
		end

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

feature -- Element change

	extend_errors (error: EL_COMMAND_ARGUMENT_ERROR)
		do
			argument_errors.extend (error)
		end

	extend_help (word_option, a_description: READABLE_STRING_GENERAL; default_value: ANY)
		do
			options_help.extend (word_option, a_description, default_value)
		end

	set_exit_code (a_exit_code: INTEGER)
		do
			exit_code := a_exit_code
		end

feature -- Factory routines

	new_application_mutex: EL_APPLICATION_MUTEX_I
		do
			create {EL_APPLICATION_MUTEX_IMP} Result.make_for_application_mode (option_name)
		end

feature {NONE} -- Factory routines

	new_argument_error (option: READABLE_STRING_GENERAL): EL_COMMAND_ARGUMENT_ERROR
		do
			create Result.make (option)
		end

	new_option_name: ZSTRING
		do
			create Result.make_from_general (option_name)
		end

	new_locale: EL_DEFERRED_LOCALE_I
		do
			create {EL_DEFERRED_LOCALE_IMP} Result.make
		end

feature {NONE} -- Implementation

	call (object: ANY)
			-- For initializing once routines
		do
		end

	create_app_directory (data_dir: EL_DIR_PATH)
		-- create cache, configuration and data user directories
		local
			legacy: like Directory.Legacy_table
		do
			legacy := Directory.Legacy_table
			-- If a differing legacy data directory exists already, move it to standard location
			if legacy.has_key (data_dir) and then legacy.found_item.exists and then legacy.found_item /~ data_dir then
				-- migrate from legacy directories
				migrate (legacy.found_item, data_dir)
			else
				File_system.make_directory (data_dir)
			end
		end

	do_application
		local
			ctrl_c_pressed: BOOLEAN
		do
			if ctrl_c_pressed then
				on_operating_system_signal
			else
				read_command_options
				if not is_valid_platform then
					lio.put_labeled_string ("Application option", option_name)
					lio.put_new_line
					lio.put_labeled_string ("This option is not designed to run on", OS_release.description)
					lio.put_new_line

				elseif Application_option.help then
					options_help.print_to_lio

				elseif has_argument_errors then
					argument_errors.do_all (agent {EL_COMMAND_ARGUMENT_ERROR}.print_to_lio)
				else
					initialize; run

					if Ask_user_to_quit then
						lio.put_new_line
						io.put_string ("<RETURN TO QUIT>")
						io.read_character
					end
				end
			end
		rescue
			-- NOTE: Windows does not trigger an exception on Ctrl-C
			if Exception.is_termination_signal then
				ctrl_c_pressed := True
				retry
			end
		end

	init_console
		local
			list: like visible_types_list
		do
			list := visible_types_list
			if not list.all_conform then
				list.log_error (lio, "Error in function `visible_types'")
			end
			Console.show_all (list.to_array)
		end

	io_put_header
		local
			build_version, test: STRING
		do
			lio.put_new_line
			test := "test"
			if Application_option.test then
				build_version := test
			else
				build_version := Build_info.version.out
			end
			lio.put_labeled_string ("Executable", Executable.name)
			lio.put_labeled_string (" Version", build_version)
			lio.put_new_line

			lio.put_labeled_string ("Class", generator)
			lio.put_labeled_string (" Option", option_name)
			lio.put_new_line
			lio.put_string_field ("Description", description)
			lio.put_new_line_X2
		end

	migrate (legacy, standard: EL_DIR_PATH)
		-- migrate legacy paths to standard
		require
			legacy_exists: legacy.exists
		do
			File_system.make_directory (standard.parent)
			OS.move_to_directory (legacy, standard.parent)
			File_system.delete_if_empty (legacy.parent)
		end

	on_operating_system_signal
			--
		do
		end

	read_command_options
		-- read command line options
		do
		end

	standard_options: EL_DEFAULT_COMMAND_OPTION_LIST
		-- Standard command line options
		do
			create Result.make (<< Base_option, Application_option >>)
		end

	visible_types: TUPLE
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

	visible_types_list: EL_TUPLE_TYPE_LIST [EL_MODULE_LIO]
		do
			create Result.make_from_tuple (visible_types)
		ensure
			all_conform_to_EL_MODULE_LIO: Result.all_conform
		end

feature {EL_DESKTOP_ENVIRONMENT_I} -- Constants

	App_directory_list: EL_ARRAYED_LIST [EL_DIR_PATH]
		once
			Result := Directory.app_list
		end

note
	descendants: "[
		**eiffel.ecf**
			EL_SUB_APPLICATION*
				[$source EL_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
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
				[$source EL_VERSION_APP]
				[$source EL_LOGGED_SUB_APPLICATION]*
					[$source EL_LOGGED_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source EL_REGRESSION_TESTABLE_SUB_APPLICATION]*
						[$source CODE_HIGHLIGHTING_TEST_APP]
						[$source SOURCE_TREE_EDITING_SUB_APPLICATION]*
							[$source UPGRADE_LOG_FILTERS_APP]
							[$source SOURCE_FILE_NAME_NORMALIZER_APP]
							[$source SOURCE_LOG_LINE_REMOVER_APP]
							[$source CLASS_PREFIX_REMOVAL_APP]
						[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source EL_AUTOTEST_SUB_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
						[$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
							[$source AUTOTEST_APP]
							[$source EDITOR_AUTOTEST_APP]
				[$source EL_STANDARD_UNINSTALL_APP]
								
		**toolkit.ecf**
			EL_SUB_APPLICATION*
				[$source BINARY_DECODE_APP]
				[$source EL_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
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
							[$source TESTABLE_LOCALIZED_THUNDERBIRD_SUB_APPLICATION]* [READER -> [$source EL_ML_THUNDERBIRD_ACCOUNT_READER] create make_from_file end]
								[$source LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP]
								[$source LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP]
					[$source EL_COMMAND_SHELL_SUB_APPLICATION]* [C -> [$source EL_COMMAND_SHELL_COMMAND]]
						[$source CRYPTO_COMMAND_SHELL_APP]
				[$source EL_VERSION_APP]
				[$source EL_LOGGED_SUB_APPLICATION]*
					[$source EL_LOGGED_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source EL_AUTOTEST_SUB_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
						[$source AUTOTEST_APP]
						[$source CAD_MODEL_AUTOTEST_APP]
					[$source EL_REGRESSION_TESTABLE_SUB_APPLICATION]*
						[$source FTP_TEST_APP]
						[$source EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
				[$source EL_STANDARD_UNINSTALL_APP]
						
		**manage-mp3.ecf**
			EL_SUB_APPLICATION*
				[$source EL_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source TANGO_MP3_FILE_COLLATOR_APP]
					[$source EL_DEBIAN_PACKAGER_APP]
					[$source GENERATE_RBOX_DATABASE_FIELD_ENUM_APP]
					[$source ID3_EDITOR_APP]
					[$source EL_LOGGED_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
						[$source MP3_AUDIO_SIGNATURE_READER_APP]
						[$source RHYTHMBOX_MUSIC_MANAGER_APP]
				[$source EL_VERSION_APP]
				[$source EL_LOGGED_SUB_APPLICATION]*
					[$source EL_LOGGED_COMMAND_LINE_SUB_APPLICATION]* [C -> [$source EL_COMMAND]]
					[$source EL_AUTOTEST_SUB_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
						[$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
							[$source AUTOTEST_APP]
				[$source EL_STANDARD_UNINSTALL_APP]

	]"
end
