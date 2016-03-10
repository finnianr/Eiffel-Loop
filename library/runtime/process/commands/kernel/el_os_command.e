note
	description: "Summary description for {EL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:19:11 GMT (Wednesday 24th July 2013)"
	revision: "3"

deferred class
	EL_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_COMMAND

	EVOLICITY_SERIALIZEABLE
		rename
			serialized_text as system_command,
			make as make_serializeable
		redefine
			utf8_encoded
		end

	EL_CROSS_PLATFORM [T]

	EL_PLATFORM_IMPL

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make
			--
		do
			make_platform
			make_serializeable
			create working_directory
		end

feature -- Access

	executable_search_path: STRING
			--
		do
			Result := environment.execution.executable_search_path
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

	utf8_encoded: BOOLEAN
		do
			Result := True
		end

feature -- Basic operations

	execute
			--
		local
			l_command, l_displayed_command: like system_command
		do
			log.enter ("execute")
			l_command := system_command

			if l_command.is_empty then
				log_or_io.put_string_field ("Error in command template", generator)
				log_or_io.put_new_line
			else
				if log.current_routine_is_active then
					l_displayed_command := l_command.twin
					l_displayed_command.replace_substring_all (
						Environment.Execution.current_working_directory.to_string, "$CWD"
					)
					l_displayed_command.replace_substring_all ("%T", "  ")
					log.put_string_field_to_max_length ("Call", l_displayed_command, 300)
					log.put_new_line
				end

				l_command.left_adjust
				do_command (l_command.translated (Tab_and_new_line, Null_and_space))
			end
			log.exit
		end

feature -- Change OS environment

	set_executable_search_path (env_path: STRING)
			--
		do
			environment.execution.set_executable_search_path (env_path)
		end

	extend_executable_search_path (path: STRING)
			--
		do
			log.enter ("extend_executable_search_path")
			environment.execution.extend_executable_search_path (path)
			log.put_string_field ("PATH", executable_search_path)
			log.exit
		end

feature {NONE} -- Implementation

	new_output_file (output_file_path: EL_FILE_PATH): PLAIN_TEXT_FILE
		do
			create Result.make_open_write (output_file_path.unicode)
		end

	new_output_lines (output_file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
		do
			Result := implementation.new_output_lines (output_file_path)
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
				previous_working_directory := Environment.Execution.current_working_directory
				environment.execution.change_working_path (working_directory.to_path)
			end

			if line_processing_enabled then
				output_file_path := temporary_file_path
				output := new_output_file (output_file_path); output.close
				a_system_command.append (file_redirection_operator)
				a_system_command.append (output_file_path.to_string)
			end

			Environment.execution.system (a_system_command.to_unicode)

			if line_processing_enabled then
				output_lines := new_output_lines (output_file_path)
				do_with_lines (output_lines)
				output_lines.delete_file
			end

			if not working_directory.is_empty then
				environment.execution.change_working_path (previous_working_directory)
			end
		end

	escaped_path (a_path: EL_PATH): EL_ASTRING
			--
		do
			Result := Environment.Operating.shell_escaped (a_path.to_string)
		end

	do_with_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
		end

	temporary_file_path: EL_FILE_PATH
			-- Tempory file in temporary area set by env label "TEMP"
		do
			Result := Environment.operating.Temp_directory_path.joined_file_path ( ("{" + generator + "}.tmp").as_string_32)
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

feature {NONE} -- Constants

	Tab_and_new_line: EL_ASTRING
		once
			Result := "%T%N"
		end

	Null_and_space: EL_ASTRING
		once
			Result := "%/000/ "
		end

end
