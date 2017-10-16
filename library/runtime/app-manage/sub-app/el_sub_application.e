note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 9:57:47 GMT (Monday 16th October 2017)"
	revision: "12"

deferred class
	EL_SUB_APPLICATION

inherit
	EL_LOGGED_APPLICATION
		export
			{NONE} all
			{ANY} Args
		end

	EL_MODULE_BUILD_INFO

	EL_MODULE_EXCEPTIONS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_IMAGE_PATH

	EL_MODULE_ZSTRING

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	initialize
			--
		deferred
		end

	make
			--
		local
			log_stack_pos: INTEGER; l_log_filters: like log_filter_list
			boolean: BOOLEAN_REF
		do
			create options_help.make (11)
			create argument_errors.make (0)
			Exceptions.catch (Exceptions.Signal_exception)

			-- Add logging menu option. The actual is_active status is tested in `EL_GLOBAL_LOGGING'
			create boolean
			across standard_options as option loop
				set_boolean_from_command_opt (boolean, option.key, option.item)
			end
			l_log_filters := log_filter_list

			init_logging (l_log_filters, Log_output_directory)

			if not (Args.has_no_app_header or Args.has_silent) then
				io_put_header (l_log_filters)
				if not Logging.is_active then
					lio.put_new_line; lio.put_new_line
				end
			end

			log.enter ("make")
			log_stack_pos := log.call_stack_count

			across User_data_directories as dir loop
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
			log.exit
			Log_manager.close_logs
			Log_manager.delete_logs

		rescue
			log.restore (log_stack_pos)
			if Exceptions.is_signal then
				on_operating_system_signal
				Exceptions.no_message_on_failure
			end
			log.exit
			Log_manager.close_logs
		end

feature -- Access

	argument_errors: ARRAYED_LIST [EL_COMMAND_ARGUMENT_ERROR]

	description: READABLE_STRING_GENERAL
		deferred
		end

	installer: EL_APPLICATION_INSTALLER_I
		do
			Result := Default_installer
		end

	new_option_name: ZSTRING
		do
			create Result.make_from_general (option_name)
		end

	option_name: READABLE_STRING_GENERAL
			-- Command option name
		do
			Result := generator.as_lower
		ensure
--			valid_name: across Result as char all char.item.is_alpha_numeric or char.item.code = {ASCII}.underlined end
		end

	options_help: EL_SUB_APPLICATION_HELP_LIST

	single_line_description: ZSTRING
		local
			lines: EL_ZSTRING_LIST
		do
			create lines.make_with_separator (description.to_string_32, '%N', True)
			Result := lines.joined_lines
		end

feature -- Basic operations

	install
		do
			installer.set_description (single_line_description)
			installer.set_command_option_name (option_name)
			installer.set_input_path_option_name (Input_path_option_name)
			installer.install
		end

	run
			--
		deferred
		end

	uninstall
			--
		do
			installer.uninstall
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

	is_installable: BOOLEAN
		do
			Result := installer /= Default_installer
		end

	is_main: BOOLEAN
			-- True if this the main (or principle) sub application in the whole set
			-- In Windows this will be the app listed in the Control Panel/Programs List
		do
			Result := False
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

	io_put_header (a_log_filters: like log_filter_list)
		local
			build_version, test: STRING
		do
			log.enter_no_header ("io_put_header")
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

			log.exit_no_trailer

			log.put_configuration_info (a_log_filters)
		end

	on_operating_system_signal
			--
		do
		end

	standard_options: EL_HASH_TABLE [STRING, STRING]
		-- Standard command line options
		do
			create Result.make (<<
				[{EL_LOG_COMMAND_OPTIONS}.Logging, 				"Activate application logging to console"],
				[{EL_LOG_COMMAND_OPTIONS}.Keep_logs, 			"Do not delete log file on program exit"],
				[{EL_LOG_COMMAND_OPTIONS}.No_highlighting, 	"Turn off color highlighting for console output"],
				[{EL_LOG_COMMAND_OPTIONS}.No_app_header, 		"Suppress output of application information"],
				[{EL_LOG_COMMAND_OPTIONS}.silent, 				"Suppress all output to console"],
				[{EL_LOG_COMMAND_OPTIONS}.Ask_user_to_quit, 	"Prompt user to quit before exiting application"]
			>>)
		end

feature {NONE} -- Factory routines

	new_argument_error (option: READABLE_STRING_GENERAL): EL_COMMAND_ARGUMENT_ERROR
		do
			create Result.make (option)
		end

	new_context_menu_installer (menu_path: ZSTRING): EL_APPLICATION_INSTALLER_I
		do
			create {EL_CONTEXT_MENU_SCRIPT_APPLICATION_INSTALLER_IMP} Result.make (menu_path)
		end

	new_launcher (a_name: ZSTRING; a_icon_path: EL_FILE_PATH): EL_DESKTOP_LAUNCHER
			--
		do
			create Result.make (a_name, "", a_icon_path)
		end

	new_menu_item (a_name, a_comment: ZSTRING; a_icon_path: EL_FILE_PATH): EL_DESKTOP_MENU_ITEM
			-- User defined submenu
		do
			create Result.make (a_name, a_comment, a_icon_path)
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

feature {EL_APPLICATION_INSTALLER_I} -- Constants

	Default_installer: EL_DO_NOTHING_INSTALLER
		once
			create Result.make_default
		end

	For_user_directories: ARRAY [FUNCTION [ZSTRING, EL_DIR_PATH]]
		once
			Result := << agent Directory.data_dir_for_user, agent Directory.configuration_dir_for_user >>
		end

	Input_path_option_name: STRING
			--
		once
			Result := "file"
		end

	Log_output_directory: EL_DIR_PATH
		once
			Result := Directory.user_data.joined_dir_steps (<< option_name.to_string_8, "logs" >>)
		end

	Template_command_error: ZSTRING
		once
			Result := "[
				Command "#" failed!
			]"
		end

	User_data_directories: ARRAY [EL_DIR_PATH]
		once
			Result := << Directory.User_data, Directory.User_configuration >>
		end

end
