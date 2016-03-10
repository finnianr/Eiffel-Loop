note
	description: "Summary description for {EL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 14:50:43 GMT (Friday 24th January 2014)"
	revision: "4"

deferred class
	EL_OS_COMMAND [T -> EL_COMMAND_IMPL create make end]

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE
		rename
			as_text as system_command,
			make_empty as make_command
		redefine
			make_default, system_command
		end

	EL_CROSS_PLATFORM [T]
		redefine
			make_default
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

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

	executable_search_path: STRING
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

	line_processing_enabled: BOOLEAN
			--
		do
		end

	back_quotes_escaped: BOOLEAN
			-- If true, back quote characters ` are escaped on posix platforms
			-- This means that commands that use BASH back-quote command substitution cannot be used
			-- without first making sure that individual path operands are escaped
		do
			Result := not {PLATFORM}.is_windows
		end

	redirect_errors: BOOLEAN
			-- True if error messages are also captured in output lines
		do
		end

	has_error: BOOLEAN
		-- True if the command returned an error code on exit

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
					display (l_command.split ('%N'))
				end
				l_command.translate (Tab_and_new_line, Null_and_space)
				do_command (l_command)
			end
			log.exit_no_trailer
		end

feature -- Change OS environment

	set_executable_search_path (env_path: STRING)
			--
		do
			Execution_environment.set_executable_search_path (env_path)
		end

	extend_executable_search_path (path: STRING)
			--
		do
			log.enter ("extend_executable_search_path")
			Execution_environment.extend_executable_search_path (path)
			log.put_string_field ("PATH", executable_search_path)
			log.exit
		end

feature {NONE} -- Implementation

	display (lines: LIST [ASTRING])
			-- display word wrapped command
		local
			current_working_directory, printable_line, name, prompt, blank_prompt, word: ASTRING
			max_width: INTEGER
		do
			current_working_directory := Directory.current_working
			name := generator
			if name.starts_with (once "EL_") then
				name.remove_head (3)
			end
			if name.ends_with (once  "_COMMAND") then
				name.remove_tail (8)
			end
			name.translate (once "_", once " ")
			create blank_prompt.make_filled (' ', name.count)
			prompt := name

			max_width := 100 - prompt.count  - 2

			create printable_line.make (200)
			across lines as line loop
				line.item.replace_substring_all (current_working_directory, "$CWD")
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
			output: PLAIN_TEXT_FILE
			output_lines: EL_FILE_LINE_SOURCE
			output_file_path: EL_FILE_PATH
		do
			if not working_directory.is_empty then
				previous_working_directory := Directory.current_working
				Execution_environment.change_working_path (working_directory)
			end

			if line_processing_enabled then
				output_file_path := temporary_file_path
				output := new_output_file (output_file_path); output.close
				a_system_command.append_string (file_redirection_operator)
				a_system_command.append (output_file_path)
				if redirect_errors then
					a_system_command.append_string (implementation.Error_redirection_suffix)
				end
			end

			has_error := False
			Execution_environment.system (a_system_command.to_unicode)
			has_error := Execution_environment.return_code /= 0

			if line_processing_enabled then
				output_lines := new_output_lines (output_file_path)
				do_with_lines (output_lines)
				output_lines.delete_file
			end

			if not working_directory.is_empty then
				Execution_environment.change_working_path (previous_working_directory)
			end
		end

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
		end

	path_arguments: ARRAYED_LIST [EL_PATH]
		local
			argument_fn: like getter_function_table.item
		do
			create Result.make (5)
			across getter_functions as function loop
				argument_fn := function.item
				if argument_fn.open_count = 0 then
					argument_fn.set_target (Current)
					argument_fn.apply
					if attached {EL_PATH} argument_fn.last_result as l_path then
						Result.extend (l_path)
					end
				end
			end
		end

	system_command: ASTRING
		local
			l_path_arguments: like path_arguments
		do
			if {PLATFORM}.is_windows then
				Result := Precursor
			else
				-- ensure all path arguments are escaped on Posix platforms
				-- Characters that have a special meaning for BASH: "`$%"\" will be escaped with a backslash
				l_path_arguments := path_arguments
				across l_path_arguments as path loop
					path.item.set_escaper (implementation.path_escaper)
				end
				Result := Precursor
				across l_path_arguments as path loop
					path.item.set_default_escaper
				end
			end
			Result.left_adjust
		end

	temporary_file_path: EL_FILE_PATH
			-- Tempory file in temporary area set by env label "TEMP"
		do
			Result := Directory.temporary + temporary_file_name
		end

	temporary_file_name: ASTRING
		do
			Result := generator
			Result.grow (Result.count + 6)
			Result.prepend_character ('{')
			Result.append_string ("}.tmp")
		end

	template: READABLE_STRING_GENERAL
			--
		do
			Result := implementation.template
		end

	file_redirection_operator: STRING
		do
			create Result.make_from_string (" >> ")
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

feature {NONE} -- Constants

	Tab_and_new_line: ASTRING
		once
			Result := "%T%N"
		end

	Null_and_space: ASTRING
		once
			Result := "%/000/ "
		end

end

