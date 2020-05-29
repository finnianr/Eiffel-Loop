note
	description: "Operating System command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-29 12:54:51 GMT (Friday 29th May 2020)"
	revision: "18"

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

	EL_MODULE_DIRECTORY

	EL_MODULE_LIO

	EL_ZSTRING_CONSTANTS

	EL_SHARED_OPERATING_ENVIRON

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

	is_forked: BOOLEAN
		-- `true' if command executes asynchronously in another system process

	is_valid_platform: BOOLEAN
		do
			Result := True
		end

feature -- Status change

	set_forking_mode (forked: BOOLEAN)
		-- when `forked' is `True', execution happens in another process
		do
			is_forked := forked
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
				words := line.item.split_intervals (character_string (' '))
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
			command_parts: EL_ZSTRING_LIST; error_path: EL_FILE_PATH
		do
			if is_forked then
				Execution_environment.launch (a_system_command)
			else
				if not working_directory.is_empty then
					Execution_environment.push_current_working (working_directory)
				end
				create command_parts.make_from_array (new_command_parts (a_system_command))
				command_parts.prune_all_empty -- `command_prefix' is empty on Unix

				error_path := temporary_error_file_path
				File_system_mutex.lock
					File_system.make_directory (error_path.parent)
				File_system_mutex.unlock

				Execution_environment.system (command_parts.joined_words)

				set_has_error (Execution_environment.return_code)
				if not working_directory.is_empty then
					Execution_environment.pop_current_working
				end
				if has_error then
					create errors.make (5)
					new_output_lines (error_path).do_all (agent errors.extend)
					on_error
				end
				File_system_mutex.lock
					if error_path.exists then
						File_system.remove_file (error_path)
					end
				File_system_mutex.unlock
			end
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

	new_command_parts (a_system_command: like system_command): ARRAY [ZSTRING]
		do
			Result := <<
				command_prefix, a_system_command, Error_redirection_operator, temporary_error_file_path
			>>
		end

	new_temporary_file_path (a_extension: STRING): EL_FILE_PATH
		-- uniquely numbered temporary file in temporary area set by env label "TEMP"
		do
			Result := Temporary_path_format #$ [
				Operating_environ.temp_directory_name, Execution_environment.Executable_and_user_name,
				new_temporary_name, once "00." + a_extension
			]
			-- check if directory already exists with root ownership (perhaps created by installer program)
			-- (Using sudo command does not mean that the user name changes to root)
			if Result.parent.exists and then not File_system.is_writeable_directory (Result.parent) then
				Result.set_parent_path (Result.parent.to_string + "-2")
			end
			Result := Result.next_version_path
		end

	new_temporary_name: ZSTRING
		do
			Result := generator
			Result.enclose ('{', '}')
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

	Error_redirection_operator: ZSTRING
		once
			Result := "2>"
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

	Temporary_path_format: ZSTRING
		once
			Result := "%S/%S/%S.00.%S"
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

feature {NONE} -- Constants

	Empty_list: EL_ZSTRING_LIST
		once ("PROCESS")
			create Result.make_empty
		end

	File_system_mutex: MUTEX
		once ("PROCESS")
			create Result.make
		end

	Temporary_error_path_by_type: EL_FUNCTION_RESULT_TABLE [EL_OS_COMMAND_I, EL_FILE_PATH]
		once
			create Result.make (17, agent {EL_OS_COMMAND_I}.new_temporary_file_path ("err"))
		end

end
