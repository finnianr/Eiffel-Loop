note
	description: "Summary description for {EL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 14:43:28 GMT (Thursday 24th December 2015)"
	revision: "6"

deferred class
	EL_OS_COMMAND [T -> EL_COMMAND_IMPL create make end]

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE
		rename
			as_text as system_command
		redefine
			make_default, system_command
		end

	EL_CROSS_PLATFORM [T]
		redefine
			make_default
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

	EL_MODULE_DIRECTORY

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_CROSS_PLATFORM}
			Precursor {EVOLICITY_SERIALIZEABLE}
			create working_directory
		end

feature -- Access

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

	line_processing_enabled: BOOLEAN
			--
		do
		end

	redirect_errors: BOOLEAN
			-- True if error messages are also captured in output lines
		do
		end

feature -- Basic operations

	execute
			--
		local
			l_command: like system_command
		do
			log.enter_no_header ("execute")
			l_command := system_command
			if l_command.is_empty then
				log_or_io.put_string_field ("Error in command template", generator)
				log_or_io.put_new_line
			else
				if log.current_routine_is_active then
					display (l_command.lines)
				end
				l_command.translate_and_delete (Tab_and_new_line, Null_and_space)
				do_command (l_command)
			end
			log.exit_no_trailer
		end

feature -- Change OS environment

	extend_executable_search_path (path: STRING)
			--
		do
			log.enter ("extend_executable_search_path")
			Execution_environment.extend_executable_search_path (path)
			log.put_string_field ("PATH", executable_search_path)
			log.exit
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
			current_working_directory, printable_line, name, prompt, blank_prompt, word: ZSTRING
			max_width: INTEGER
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
				across line.item.split (' ') as l_word loop
					word := l_word.item
					if not word.is_empty then
						if not printable_line.is_empty then
							printable_line.append_character (' ')
						end
						printable_line.append (word)
						if printable_line.count > max_width then
							printable_line.remove_tail (word.count)
							log.put_labeled_string (prompt, printable_line)
							log.put_new_line
							printable_line.wipe_out
							printable_line.append (word)
							prompt := blank_prompt
						end
					end
				end
			end
			log.put_labeled_string (prompt, printable_line)
			log.put_new_line
		end

	do_command (a_system_command: like system_command)
			--
		local
			previous_working_directory: like working_directory
			output: PLAIN_TEXT_FILE; output_lines: EL_FILE_LINE_SOURCE; output_file_path: EL_FILE_PATH
		do
			if not working_directory.is_empty then
				previous_working_directory := Directory.current_working
				Execution_environment.change_working_path (working_directory)
			end

			if line_processing_enabled then
				output_file_path := temporary_file_path
				output := new_output_file (output_file_path); output.close
				a_system_command.append_string (file_redirection_operator)
				a_system_command.append_string (output_file_path.to_string)
				if redirect_errors then
					a_system_command.append_string (implementation.Error_redirection_suffix)
				end
			end

			has_error := False
			Execution_environment.system (a_system_command.to_unicode)
			has_error := Execution_environment.return_code /= 0

			if not working_directory.is_empty then
				Execution_environment.change_working_path (previous_working_directory)
			end

			if line_processing_enabled then
				output_lines := new_output_lines (output_file_path)
				do_with_lines (output_lines)
				output_lines.delete_file
			end
		end

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
		end

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := implementation.escaped_path (a_path)
		end

	file_redirection_operator: ZSTRING
		do
			Result := " >> "
		ensure
			padded_with_spaces: Result.item (1) = ' ' and Result.item (Result.count) = ' '
		end

	new_output_file (output_file_path: EL_FILE_PATH): PLAIN_TEXT_FILE
		do
			create Result.make_open_write (output_file_path)
		end

	new_output_lines (output_file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
		do
			Result := implementation.new_output_lines (output_file_path)
		end

	system_command: ZSTRING
		do
			Result := Precursor
			Result.left_adjust
		end

	template: READABLE_STRING_GENERAL
			--
		do
			Result := implementation.template
		end

	temporary_file_name: ZSTRING
		do
			Result := generator
			Result.grow (Result.count + 6)
			Result.prepend_character ('{')
			Result.append_string_general ("}.tmp")
		end

	temporary_file_path: EL_FILE_PATH
			-- Tempory file in temporary area set by env label "TEMP"
		do
			Result := Directory.temporary + temporary_file_name
		end

feature {NONE} -- Constants

	Null_and_space: ZSTRING
		once
			Result := "%U "
		end

	Tab_and_new_line: ZSTRING
		once
			Result := "%T%N"
		end

	EL_prefix: ZSTRING
		once
			Result := "EL_"
		end

	Command_suffix: ZSTRING
		once
			Result := "_COMMAND"
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

end

