note
	description: "Summary description for {EL_OS_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 9:56:04 GMT (Friday 10th November 2017)"
	revision: "8"

deferred class
	EL_OS_COMMAND_I

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE
		rename
			as_text as system_command
		redefine
			make_default, system_command
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_STRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			create working_directory
			errors := Empty_list
			Precursor
		end

feature -- Access

	errors: EL_ZSTRING_LIST

	executable_search_path: ZSTRING
			--
		do
			Result := Execution_environment.executable_search_path
		end

	working_directory: EL_DIR_PATH

feature -- Element change

	set_working_directory (a_working_directory: like working_directory)
			--
		do
			working_directory := a_working_directory
		end

feature -- Status query

	back_quotes_escaped: BOOLEAN
			-- If true, back quote characters ` are escaped on posix platforms
			-- This means that commands that use BASH back-quote command substitution cannot be used
			-- without first making sure that individual path operands are escaped
		do
			Result := not {PLATFORM}.is_windows
		end

	has_error: BOOLEAN
		-- True if the command returned an error code on exit

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

feature -- Basic operations

	execute
			--
		require else
			valid_platform: is_valid_platform
		local
			l_command: like system_command
		do
			reset
			l_command := system_command
			if l_command.is_empty then
				lio.put_string_field ("Error in command template", generator)
				lio.put_new_line
			else
				if is_lio_enabled then
					display (l_command.lines)
				end
				l_command.translate_and_delete (Tab_and_new_line, Null_and_space)
				do_command (l_command)
			end
		end

feature -- Change OS environment

	extend_executable_search_path (path: STRING)
			--
		do
			Execution_environment.extend_executable_search_path (path)
		end

	set_executable_search_path (env_path: STRING)
			--
		do
			Execution_environment.set_executable_search_path (env_path)
		end

feature {NONE} -- Implementation

	display (lines: LIST [ZSTRING])
			-- display word wrapped command
		local
			current_working_directory, printable_line, name, prompt, blank_prompt: ZSTRING
			max_width: INTEGER; words: EL_SEQUENTIAL_INTERVALS
		do
			current_working_directory := Directory.current_working
			name := generator
			if name.starts_with (EL_prefix) then
				name.remove_head (3)
			end
			if name.ends_with (Command_suffix) then
				name.remove_tail (8)
			end
			name.replace_character ('_', ' ')
			create blank_prompt.make_filled (' ', name.count)
			prompt := name

			max_width := 100 - prompt.count  - 2

			create printable_line.make (200)
			across lines as line loop
				line.item.replace_substring_all (current_working_directory, Variable_cwd)
				line.item.left_adjust
				words := line.item.split_intervals (Space_string)
				from words.start until words.after loop
					if words.item_count > 0 then
						if not printable_line.is_empty then
							printable_line.append_character (' ')
						end
						printable_line.append_substring (line.item, words.item_lower, words.item_upper)
						if printable_line.count > max_width then
							printable_line.remove_tail (words.item_count)
							lio.put_labeled_string (prompt, printable_line)
							lio.put_new_line
							printable_line.wipe_out
							printable_line.append_substring (line.item, words.item_lower, words.item_upper)
							prompt := blank_prompt
						end
					end
					words.forth
				end
			end
			lio.put_labeled_string (prompt, printable_line)
			lio.put_new_line
		end

	do_command (a_system_command: like system_command)
			--
		local
			command_string: like new_command_string; error_path: EL_FILE_PATH
		do
			if not working_directory.is_empty then
				Execution_environment.push_current_working (working_directory)
			end
			command_string := new_command_string (a_system_command)

			error_path := temporary_error_file_path
			File_system.make_directory (error_path.parent)

			Execution_environment.system (command_string)
			set_has_error (Execution_environment.return_code)
			if not working_directory.is_empty then
				Execution_environment.pop_current_working
			end
			if has_error then
				create errors.make (5)
				new_output_lines (error_path).do_all (agent errors.extend)
				on_error
			end
			File_system.remove_file (error_path)
		end

	on_error
		do
		end

	reset
			-- Executed before do_command
		do
			errors := Empty_list
			has_error := False
		end

	set_has_error (return_code: INTEGER)
		do
			has_error := return_code /= 0
		end

	system_command: ZSTRING
		do
			Result := Precursor
			Result.left_adjust
		end

	temporary_error_file_path: EL_FILE_PATH
		do
			Result := Temporary_error_path_by_type.item (Current)
		end

feature {EL_OS_COMMAND_I} -- Factory

	new_command_string (a_system_command: like system_command): STRING_32
		local
			system_cmd_32, error_file_path: STRING_32
		do
			system_cmd_32 := a_system_command
			error_file_path := temporary_error_file_path.as_string_32
			create Result.make (
				command_prefix.count +  system_cmd_32.count +  Error_redirection_operator.count +  error_file_path.count
			)
			Result.append (command_prefix); Result.append (system_cmd_32)
			Result.append (Error_redirection_operator); Result.append (error_file_path)
		end

	new_temporary_base_name (a_extension: STRING): ZSTRING
		do
			Result := generator
			Result.grow (Result.count + 6)
			Result.prepend_character ('{'); Result.append_character ('}')
			Result.append_character ('.')
			Result.append_string_general (a_extension)
		end

	new_temporary_file_path (a_extension: STRING): EL_FILE_PATH
			-- Tempory file in temporary area set by env label "TEMP"
		do
			Result := Directory.temporary.joined_file_steps (<<
				Execution_environment.Executable_and_user_name, new_temporary_base_name (a_extension)
			>>)
		end

feature {NONE} -- Deferred implementation

	command_prefix: STRING_32
			-- For Windows to force unicode output using "cmd /U /C"
			-- Empty in Unix
		deferred
		end

	new_output_lines (file_path: EL_FILE_PATH): EL_LINEAR [ZSTRING]
		deferred
		end

	template: READABLE_STRING_GENERAL
			--
		deferred
		end

feature {NONE} -- Constants

	Command_suffix: ZSTRING
		once
			Result := "_COMMAND"
		end

	EL_prefix: ZSTRING
		once
			Result := "EL_"
		end

	Empty_list: EL_ZSTRING_LIST
		once ("PROCESS")
			create Result.make_empty
		end

	Error_redirection_operator: STRING_32
		once
			Result := " 2> "
		end

	Extension_err: ZSTRING
		once
			Result := "err"
		end

	Extension_txt: ZSTRING
		once
			Result := "txt"
		end

	Null_and_space: ZSTRING
		once
			Result := "%U "
		end

	Tab_and_new_line: ZSTRING
		once
			Result := "%T%N"
		end

	Temporary_error_path_by_type: EL_FUNCTION_RESULT_TABLE [EL_OS_COMMAND_I, EL_FILE_PATH]
		once
			create Result.make (17, agent {EL_OS_COMMAND_I}.new_temporary_file_path ("err"))
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

end
