indexing
	description: "Summary description for {EL_OS_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			serialized_text as system_command,
			make as make_serializeable
		end

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_FILE

	EL_MODULE_STRING

	PLATFORM

feature {NONE} -- Initialization

	make is
			--
		do
			create implementation
			make_serializeable
			create working_directory.make_empty
		end

feature -- Access

	executable_search_path: STRING is
			--
		do
			Result := environment.execution.executable_search_path
		end

feature -- Element change

	set_working_directory (a_working_directory: STRING) is
			--
		do
			working_directory := a_working_directory
		end

feature -- Status query

	line_processing_enabled: BOOLEAN is
			--
		do
		end

feature -- Basic operations

	execute is
			--
		local
			adjusted_system_command: like system_command

		do
			adjusted_system_command := system_command
			if not adjusted_system_command.is_empty then
				adjusted_system_command.left_adjust
				String.subst_all_characters (adjusted_system_command, '%N', ' ')
				adjusted_system_command.prune_all ('%T')
				do_command (adjusted_system_command)
			else
				log_or_io.put_string_field ("Error in command template", generator)
				log_or_io.put_new_line
			end
		end

feature -- Change OS environment

	set_executable_search_path (env_path: STRING) is
			--
		do
			environment.execution.set_executable_search_path (env_path)
		end

	extend_executable_search_path (path: STRING) is
			--
		do
			log.enter ("extend_executable_search_path")
			environment.execution.extend_executable_search_path (path)
			log.put_string_field ("PATH", executable_search_path)
			log.exit
		end

feature {NONE} -- Implementation

	do_command (a_system_command: like system_command) is
			--
		local
			previous_working_directory: like working_directory
			output_file_path: FILE_NAME
			output_lines: EL_FILE_STRING_LIST
		do
			if not working_directory.is_empty then
				previous_working_directory := environment.execution.current_working_directory
				environment.execution.change_working_directory (working_directory)
			end

			if line_processing_enabled then
				output_file_path := temporary_file_path
				a_system_command.append (" > ")
				a_system_command.append (output_file_path)
			end

			log_or_io.put_string ("OS call> ")
			log_or_io.put_string (a_system_command)
			log_or_io.put_new_line
			Environment.execution.system (a_system_command)

			if line_processing_enabled then
				create output_lines.make (output_file_path)
				do_with_lines (output_lines)
				output_lines.close
			end

			if not working_directory.is_empty then
				environment.execution.change_working_directory (previous_working_directory)
			end
		end

	do_with_lines (lines: EL_FILE_STRING_LIST) is
			--
		do
		end

	temporary_file_path: FILE_NAME is
			-- Tempory file in temporary area set by env label "TEMP"
		do
			Result := File.joined_path (
				File.directory_name (Environment.operating.Temp_directory_name),
				"{" + generator + "}.tmp"
			)
		end

	template: STRING is
			--
		do
			Result := implementation.template
		end

	working_directory: STRING

	implementation: T

end

