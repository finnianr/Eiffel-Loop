note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-04 13:19:13 GMT (Friday 4th March 2016)"
	revision: "7"

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

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	make
			--
		local
			log_stack_pos: INTEGER
			l_log_filters: like log_filter_array
		do
			create options_help.make
			Exceptions.catch (Exceptions.Signal_exception)

			create is_logging_active
			set_boolean_from_command_opt (is_logging_active, {EL_LOG_COMMAND_OPTIONS}.Logging, "Activate application logging to console")

			l_log_filters := log_filter_array
			init_logging (is_logging_active.item, l_log_filters, Log_output_directory)
			io_put_header (l_log_filters)
			log_or_io.put_new_line

			log.enter ("make")
			log_stack_pos := log.call_stack_count;

			across User_data_directories as dir loop
				if not dir.item.exists then
					File_system.make_directory (dir.item)
				end
			end
			initialize
			if command_line_help_option_exists then
				print_command_option_help

			elseif has_invalid_argument then
				put_command_failed_error
			else
				run
				if Ask_user_to_quit then
					log_or_io.put_new_line
					log_or_io.put_string ("<RETURN TO QUIT>")
					io.read_character
				end
			end
			log.exit
			log_manager.close_logs
			log_manager.delete_logs

		rescue
			log.restore (log_stack_pos)
			if Exceptions.is_signal then
				on_operating_system_signal
				Exceptions.no_message_on_failure
			end
			log.exit
			Log_manager.close_logs
		end

	initialize
			--
		deferred
		end

feature -- Access

	option_name: READABLE_STRING_GENERAL
			-- Command option name
		do
			Result := generator.as_lower
		ensure
--			valid_name: across Result as char all char.item.is_alpha_numeric or char.item.code = {ASCII}.underlined end
		end

	new_option_name: ZSTRING
		do
			create Result.make_from_unicode (option_name)
		end

	description: STRING
		deferred
		end

	single_line_description: STRING
		local
			l_lines: EL_STRING_LIST [STRING]
		do
			create l_lines.make_with_lines (description)
			if l_lines.count = 1 then
				Result := l_lines.first
			else
				l_lines.do_all (agent {STRING}.left_adjust)
				Result := l_lines.joined_lines
			end
		end

	installer: EL_APPLICATION_INSTALLER
		do
			Result := Default_installer
		end

feature -- Basic operations

	run
			--
		deferred
		end

	install
		do
			installer.set_description (single_line_description)
			installer.set_command_option_name (option_name.as_string_8)
			installer.set_input_path_option_name (Input_path_option_name)
			installer.install
		end

	uninstall
			--
		do
			installer.uninstall
		end

	print_command_option_help
		do
			log_or_io.put_line ("COMMAND LINE OPTIONS:")
			log_or_io.put_new_line

			across options_help as option loop
				log_or_io.put_line (indent (4) + "-" + option.item.name + ":")
				log_or_io.put_line (indent (8) + option.item.description)
				if not option.item.default_value.is_empty then
					log_or_io.put_line (indent (8) + "Default: " + option.item.default_value)
				end
				log_or_io.put_new_line
			end

		end

feature -- Status query

	has_invalid_argument: BOOLEAN

	is_logging_active: BOOLEAN_REF

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

feature {NONE} -- Element change

	set_app_configuration_option_name (a_name: STRING)
			-- set once attribute 'Application_sub_option' in class EL_APPLICATION_CONFIG_CELL
		local
			config_cell: EL_APPLICATION_CONFIG_CELL [EL_FILE_PERSISTENT_IMPL]
		do
			create config_cell.make_from_option_name (a_name)
		end

	set_attribute_from_command_opt (a_attribute: ANY; a_word_option, a_description: STRING)
		do
			set_from_command_opt (a_attribute, a_word_option, a_description, False)
		end

	set_required_attribute_from_command_opt (a_attribute: ANY; a_word_option, a_description: STRING)
		do
			set_from_command_opt (a_attribute, a_word_option, a_description, True)
		end

	set_from_command_opt (
		a_attribute: ANY; a_word_option, a_description: STRING; is_required: BOOLEAN
	)
			-- set class attribute from command line option
		local
			l_argument_index: INTEGER
			l_argument: ZSTRING
		do
			options_help.extend ([a_word_option, a_description, a_attribute.out])
			if Args.has_value (a_word_option) then
				l_argument_index := Args.index_of_word_option (a_word_option) + 1
				l_argument := Args.item (l_argument_index)

				if attached {ZSTRING} a_attribute as a_string then
					a_string.share (l_argument)

				elseif attached {EL_DIR_PATH} a_attribute as a_dir_path then
					a_dir_path.set_path (l_argument)
					if not a_dir_path.exists then
						set_path_argument_error (a_word_option, English_directory, a_dir_path)
					end

				elseif attached {EL_FILE_PATH} a_attribute as a_file_path then
					a_file_path.set_path (l_argument)
					if not a_file_path.exists then
						set_path_argument_error (a_word_option, English_file, a_file_path)
					end

				elseif attached {REAL_REF} a_attribute as a_real_value then
					if l_argument.is_real then
						a_real_value.set_item (l_argument.to_real)
					else
						set_argument_type_error (a_word_option, English_real_number)
					end

				elseif attached {INTEGER_REF} a_attribute as a_integer_value then
					if l_argument.is_integer then
						a_integer_value.set_item (l_argument.to_integer)
					else
						set_argument_type_error (a_word_option, English_integer)
					end
				elseif attached {BOOLEAN_REF} a_attribute as a_boolean_value then
					a_boolean_value.set_item (Args.word_option_exists (a_word_option))

				elseif attached {EL_ZSTRING_HASH_TABLE [STRING]} a_attribute as hash_table then
					hash_table [a_word_option] := l_argument
				end
			else
				if is_required then
					set_required_argument_error (a_word_option)
				end
			end
		end

	set_boolean_from_command_opt (a_bool: BOOLEAN_REF; a_word_option, a_description: STRING)
		local
			default_value: STRING
		do
			if a_bool.item then
				default_value := "on"
			else
				default_value := "off"
			end
			if a_bool.item and then Args.word_option_exists (a_word_option) then
				a_bool.set_item (False)
			else
				a_bool.set_item (Args.word_option_exists (a_word_option))
			end
			options_help.extend ([a_word_option, a_description, default_value])
		end

	set_path_argument_error (a_word_option, path_type: STRING; a_path: EL_PATH)
		do
			put_log_message (Template_path_error, [path_type, a_word_option, path_type, a_path.to_string])
			has_invalid_argument := True
		end

	set_required_argument_error (a_word_option: STRING)
		do
			put_log_message (Template_required_argument_error, [a_word_option])
			has_invalid_argument := True
		end

	set_missing_argument_error (a_word_option: STRING)
		do
			put_log_message (Template_missing_argument_error, [a_word_option])
			has_invalid_argument := True
		end

	set_argument_type_error (a_word_option, a_type: STRING)
		do
			put_log_message (Template_type_error, [a_word_option, a_type])
			has_invalid_argument := True
		end

	put_command_failed_error
		do
			log_or_io.put_new_line
			put_log_message (Template_command_error, [option_name.as_string_8])
		end

	put_log_message (a_template: ZSTRING; a_inserts: TUPLE)
		do
			log_or_io.put_line (a_template #$ a_inserts)
		end

feature {NONE} -- Implementation

	on_operating_system_signal
			--
		do
		end

	User_data_directories: ARRAY [EL_DIR_PATH]
		once
			Result := << Directory.User_data, Directory.User_configuration >>
		end

	io_put_header (a_log_filters: like log_filter_array)
		local
			build_version, test: STRING
		do
			log.enter_no_header ("io_put_header")
			log_or_io.put_new_line
			test := "test"
			if Args.argument_count >= 2 and then Args.item (2).same_string (test) then
				build_version := test
			else
				build_version := Build_info.version.out
			end
			log_or_io.put_labeled_string ("Executable", Execution.executable_path.base)
			log_or_io.put_labeled_string (" Version", build_version)
			log_or_io.put_new_line

			log_or_io.put_labeled_string ("Class", generator)
			log_or_io.put_labeled_string (" Option", option_name)
			log_or_io.put_new_line
			log_or_io.put_string_field ("Description", description)

			log.exit_no_trailer

			log.put_configuration_info (a_log_filters)
			log_or_io.put_new_line
		end

	indent (n: INTEGER): STRING
		do
			create Result.make_filled (' ', n)
		end

	call (object: ANY)
			-- For initialzing once routines
		do
		end

	options_help: LINKED_LIST [TUPLE [name, description, default_value: STRING]]

feature {NONE} -- Factory routines

	new_menu_item (a_name, a_comment: STRING_8; a_icon_path: EL_FILE_PATH): EL_DESKTOP_MENU_ITEM
			-- User defined submenu
		do
			create Result.make (a_name, a_comment, a_icon_path)
		end

	new_launcher (a_name: STRING; a_icon_path: EL_FILE_PATH): EL_DESKTOP_LAUNCHER
			--
		do
			create Result.make (a_name, "", a_icon_path)
		end

feature {EL_APPLICATION_INSTALLER} -- Constants

	Default_installer: EL_DO_NOTHING_INSTALLER
		once
			create Result
		end

	Log_output_directory: EL_DIR_PATH
		local
			l_steps: EL_PATH_STEPS
		once
			l_steps := Directory.user_data
			l_steps.extend (create {ZSTRING}.make_from_unicode (option_name))
			l_steps.extend ("logs")
			Result := l_steps
		end

	Input_path_option_name: STRING
			--
		once
			Result := "file"
		end

	Template_required_argument_error: ZSTRING
		once
			Result := "[
				A required argument "-#" is not specified.
			]"
		end

	Template_missing_argument_error: ZSTRING
		once
			Result := "[
				The word option "-#" is not followed by an argument.
			]"
		end

	Template_path_error: ZSTRING
		once
			Result := "[
				ERROR in # argument: "-#"
				The #: "#" does not exist.
			]"
		end

	Template_type_error: ZSTRING
		once
			Result := "[
				ERROR: option "-#" is not followed by a #
			]"
		end

	Template_command_error: ZSTRING
		once
			Result := "[
				Command "#" failed!
			]"
		end

	English_directory: STRING
		once
			Result := "directory"
		end

	English_file: STRING
		once
			Result := "file"
		end

	English_real_number: STRING
		once
			Result := "real number"
		end

	English_integer: STRING
		once
			Result := "integer"
		end

end
