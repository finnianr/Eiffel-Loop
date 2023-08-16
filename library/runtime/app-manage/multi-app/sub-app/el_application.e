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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 9:32:29 GMT (Wednesday 16th August 2023)"
	revision: "73"

deferred class
	EL_APPLICATION

inherit
	EL_FALLIBLE
		export
			{NONE} all
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_BUILD_INFO; EL_MODULE_EXCEPTION; EL_MODULE_EXECUTABLE; EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM; EL_MODULE_LIO; EL_MODULE_OS_RELEASE; EL_MODULE_OS

	EL_SHARED_BASE_OPTION; EL_SHARED_APPLICATION_OPTION

	EL_CHARACTER_CONSTANTS

feature {EL_FACTORY_CLIENT} -- Initialization

	initialize
			--
		deferred
		end

	make
			--
		do
			make_default
			across App_directory_list as list loop
				if not list.item.exists then
					create_app_directory (list.item)
				end
			end
			init_console
			if not (App_option.no_app_header or Base_option.silent) then
				io_put_header
			end
			if help_requested then
				print_help

			elseif not is_valid_platform then
				print_platform_help (0)

			else
				do_application
			end
		end

	make_default
		do
			make_solitary

			Directory.set_sub_app_option_name (option_name)

			-- Necessary to redefine `Build_info' as type `BUILD_INFO' if the project root class is `Current'
			call (Build_info)

			Exception.catch ({EXCEP_CONST}.Signal_exception)
			across standard_options as opt loop
				do_nothing
			end
		end

feature -- Access

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

	options_help: EL_APPLICATION_HELP_LIST
		do
			create Result.make (11)
			across standard_options as options loop
				across options.item.help_table as help loop
					Result.extend (help.key, help.item.description, help.item.default_value)
				end
			end
		end

	unwrapped_description: ZSTRING
	 -- description unwrapped as a single line
		do
			create Result.make_from_general (description)
			Result.replace_character ('%N', ' ')
		end

	user_config_dir: DIR_PATH
		do
			Result := Directory.app_configuration #+ new_option_name
		end

feature -- Basic operations

	run
			--
		deferred
		end

	print_help
		do
			options_help.print_to_lio
			if not is_valid_platform then
				lio.put_line ("WARNING")
				lio.put_spaces (4)
				print_platform_help (4)
			end
		end

	print_platform_help (indent_count: INTEGER)
		do
			lio.put_labeled_substitution (
				Hyphen #* 1 + option_name, "this option is not designed for use on %S", [ OS_release.description]
			)
			lio.put_new_line
		end

feature -- Status query

	ask_user_to_quit: BOOLEAN
			--
		do
			Result := App_option.ask_user_to_quit
		end

	help_requested: BOOLEAN
		-- `True' if user requested help or other information
		do
			Result := App_option.help
		end

	is_same_option (name: ZSTRING): BOOLEAN
		do
			Result := name.same_string_general (option_name)
		end

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

feature -- Element change

	set_exit_code (a_exit_code: INTEGER)
		do
			exit_code := a_exit_code
		end

feature {EL_APPLICATION} -- Factory routines

	new_application_mutex: EL_APPLICATION_MUTEX_I
		do
			create {EL_APPLICATION_MUTEX_IMP} Result.make_for_application_mode (option_name)
		end

	new_command_options: EL_APPLICATION_COMMAND_OPTIONS
		do
			create Result.make
		end

	new_configuration: detachable EL_APPLICATION_CONFIGURATION
		-- redefine to create configuration singleton just before `initialization' routine is called
		do
		end

	new_option_name: ZSTRING
		do
			create Result.make_from_general (option_name)
		end

feature {NONE} -- Implementation

	call (object: ANY)
			-- For initializing once routines
		do
		end

	create_app_directory (data_dir: DIR_PATH)
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
			ctrl_c_pressed: BOOLEAN; l_timer: EL_EXECUTION_TIMER
		do
			if ctrl_c_pressed then
				on_operating_system_signal
			else
				if App_option.show_benchmarks then
					create l_timer.make; l_timer.start
					internal_timer := l_timer
				end
				read_command_options
				if has_error then
					print_errors (lio)
				else
					call (new_configuration)
					initialize; run

					if attached internal_timer as timer then
						show_benchmarks (timer)
					end
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

			elseif attached Exception.last_exception.cause as cause then
				lio.put_labeled_substitution (
					cause.generator, "{%S}.%S Line %S", [cause.type_name, cause.recipient_name, cause.line_number]
				)
				lio.put_new_line
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
			if App_option.test then
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

	migrate (legacy, standard: DIR_PATH)
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

	show_benchmarks (timer: EL_EXECUTION_TIMER)
		-- show execution times and average execution time since last version update
		local
			timer_data: RAW_FILE; data_version: NATURAL; i, data_count: INTEGER
			sum_elapsed_times: DOUBLE; file_path: FILE_PATH
		do
			file_path := Directory.Sub_app_data + "show_benchmarks.dat"
			timer.stop
			across (";Average ").split (';') as l_prefix loop
				lio.put_labeled_string (l_prefix.item + "Execution time", timer.elapsed_time.out)
				lio.put_new_line
				if l_prefix.is_first then
					-- Set average elapsed time from previous runs
					if file_path.exists then
						create timer_data.make_open_read (file_path)
						timer_data.read_natural
						data_version := timer_data.last_natural
						data_count := (timer_data.count - {PLATFORM}.Natural_32_bytes) // {PLATFORM}.Real_64_bytes
						from i := 1 until i > data_count loop
							timer_data.read_double
							sum_elapsed_times := sum_elapsed_times + timer_data.last_double
							i := i + 1
						end
					else
						File_system.make_directory (file_path.parent)
						create timer_data.make_open_write (file_path)
						timer_data.put_natural_32 (Build_info.version_number)
						data_version := Build_info.version_number
					end
					timer_data.close
					if Build_info.version_number > data_version then
						-- Reset file to zero items
						create timer_data.make_open_write (file_path)
						timer_data.put_natural_32 (Build_info.version_number)
						sum_elapsed_times := 0; data_count := 0
					else
						create timer_data.make_open_append (file_path)
					end
					timer_data.put_double (timer.elapsed_millisecs)
					timer_data.close
					lio.put_integer_field ("Previous runs", data_count)
					lio.put_new_line
					sum_elapsed_times := sum_elapsed_times + timer.elapsed_millisecs
					data_count := data_count + 1
					timer.set_elapsed_millisecs (sum_elapsed_times / data_count)
				end
			end
		end

	standard_options: EL_DEFAULT_COMMAND_OPTION_LIST
		-- Standard command line options
		do
			create Result.make (<< Base_option, new_command_options >>)
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

feature {NONE} -- Internal attributes

	internal_timer: detachable EL_EXECUTION_TIMER

feature {EL_DESKTOP_ENVIRONMENT_I} -- Constants

	App_directory_list: EL_ARRAYED_LIST [DIR_PATH]
		once
			Result := Directory.app_list
		end

note
	descendants: "[
		**eiffel.ecf**
			EL_APPLICATION*
				[$source VERSION_MANAGER_APP]
				[$source EL_COMMAND_LINE_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND]]
					[$source GITHUB_MANAGER_APP]
					[$source ECF_TO_PECF_APP]
					[$source PYXIS_TRANSLATION_TREE_COMPILER_APP]
					[$source PYXIS_ECF_CONVERTER_APP]
					[$source WINZIP_SOFTWARE_PACKAGE_BUILDER_APP]
					[$source CHECK_LOCALE_STRINGS_APP]
					[$source CLASS_DESCENDANTS_APP]
					[$source FEATURE_EDITOR_APP]
					[$source OPEN_GREP_RESULT_APP]
					[$source ID3_FRAME_CODE_CLASS_GENERATOR_APP]
					[$source LIBRARY_OVERRIDE_APP]
					[$source REPOSITORY_PUBLISHER_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND]]
						[$source EIFFEL_VIEW_APP]
						[$source IMP_CLASS_LOCATION_NORMALIZER_APP]
						[$source REPOSITORY_SOURCE_LINK_EXPANDER_APP]
						[$source REPOSITORY_NOTE_LINK_CHECKER_APP]
					[$source SOURCE_MANIFEST_APPLICATION]* [COMMAND -> [$source SOURCE_MANIFEST_COMMAND]]
						[$source LIBRARY_MIGRATION_APP]
						[$source UNDEFINE_PATTERN_COUNTER_APP]
						[$source UPGRADE_DEFAULT_POINTER_SYNTAX_APP]
						[$source UPGRADE_LOG_FILTERS_APP]
						[$source UPGRADE_TEST_SET_CALL_BACK_CODE_APP]
						[$source CODEBASE_STATISTICS_APP]
						[$source ENCODING_CHECK_APP]
						[$source REGULAR_EXPRESSION_SEARCH_APP]
						[$source CLASS_RENAMING_APP]
						[$source FIND_AND_REPLACE_APP]
						[$source NOTE_EDITOR_APP]
							[$source NOTE_DATE_FIXER_APP]
						[$source SOURCE_FILE_NAME_NORMALIZER_APP]
						[$source SOURCE_LEADING_SPACE_CLEANER_APP]
						[$source SOURCE_LOG_LINE_REMOVER_APP]
					[$source ZCODEC_GENERATOR_APP]
				[$source EL_VERSION_APP]
				[$source EL_STANDARD_UNINSTALL_APP]
				[$source EL_LOGGED_APPLICATION]*
					[$source EL_AUTOTEST_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
						[$source EL_CRC_32_AUTOTEST_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
							[$source AUTOTEST_APP]

		**toolkit.ecf**
	descendants: "[
			EL_APPLICATION*
				[$source BINARY_DECODE_APP]
				[$source DIAGNOSTICS_APP]
				[$source EL_COMMAND_LINE_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND]]
					[$source SLIDE_SHOW_APP]
					[$source STOCK_CONSUMPTION_CALCULATOR_APP]
					[$source UNDATED_PHOTO_FINDER_APP]
					[$source USER_AGENT_APP]
					[$source WEBSITE_MONITOR_APP]
					[$source XML_TO_PYXIS_APP]
					[$source YOUTUBE_VIDEO_DOWNLOADER_APP]
					[$source EL_DEBIAN_PACKAGER_APP]
					[$source DUPLICITY_BACKUP_APP]
					[$source DUPLICITY_RESTORE_APP]
					[$source FILE_TREE_TRANSFORM_SCRIPT_APP]
					[$source FTP_BACKUP_APP]
					[$source FILE_MANIFEST_APP]
					[$source CURRENCY_EXCHANGE_HISTORY_APP]
					[$source HTML_BODY_WORD_COUNTER_APP]
					[$source PYXIS_ENCRYPTER_APP]
					[$source PYXIS_TO_XML_APP]
					[$source PYXIS_TREE_TO_XML_COMPILER_APP]
					[$source EL_LOGGED_COMMAND_LINE_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND]]
						[$source LOCALIZATION_COMMAND_SHELL_APP]
						[$source CAD_MODEL_SLICER_APP]
						[$source FILTER_INVALID_UTF_8_APP]
						[$source PRAAT_GCC_SOURCE_TO_MSVC_CONVERTOR_APP]
					[$source THUNDERBIRD_ACCOUNT_READER_APP]* [C -> [$source TB_ACCOUNT_READER] create make_from_file end]
						[$source LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP]
						[$source LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP]
						[$source THUNDERBIRD_BOOK_EXPORTER_APP]
						[$source THUNDERBIRD_WWW_EXPORTER_APP]
					[$source VCF_CONTACT_NAME_APPLICATION]*
						[$source VCF_CONTACT_SPLITTER_APP]
						[$source VCF_CONTACT_NAME_SWITCHER_APP]
					[$source EL_COMMAND_SHELL_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND_SHELL]]
						[$source CRYPTO_COMMAND_SHELL_APP]
					[$source FILE_SYNC_APP]
					[$source CAMERA_TRANSFER_APP]
				[$source EL_VERSION_APP]
				[$source EL_LOGGED_APPLICATION]*
					[$source EL_LOGGED_COMMAND_LINE_APPLICATION]* [C -> [$source EL_APPLICATION_COMMAND]]
					[$source EL_AUTOTEST_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
						[$source EL_CRC_32_AUTOTEST_APPLICATION]* [EQA_TYPES -> [$source TUPLE] create default_create end]
							[$source AUTOTEST_APP]
							[$source FTP_AUTOTEST_APP]
				[$source EL_STANDARD_UNINSTALL_APP]
	]"
end