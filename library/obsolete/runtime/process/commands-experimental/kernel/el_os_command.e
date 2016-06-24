note
	description: "Summary description for {EL_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	PROCESS_FACTORY

	EL_CROSS_PLATFORM [T]

	EL_PLATFORM_IMPL

	EL_MODULE_ENVIRONMENT

	EL_MODULE_LOG

	EL_MODULE_STRING

	EL_MODULE_FILE

feature {NONE} -- Initialization

	make
			--
		do
			make_platform
			create working_directory.make_empty
			create argument_list.make
			create accumulated_line.make_empty
			create error_lines.make (3)
		end

feature -- Access

	executable_search_path: STRING
			--
		do
			Result := environment.execution.executable_search_path
		end

	program_name: STRING
		do
			Result := implementation.program_path
		end

	working_directory: STRING

feature -- Element change

	set_working_directory (a_working_directory: STRING)
			--
		do
			working_directory := a_working_directory
		end

feature -- Status change

	set_latin1_path_encoding
			--
		do
			is_path_latin1 := True
		end

	set_utf8_path_encoding
			--
		do
			is_path_latin1 := False
		end

feature -- Status query

	is_path_latin1: BOOLEAN
		-- paths encoded as latin1
		-- utf8 if false

	has_error: BOOLEAN

feature -- Basic operations

	execute
			--
		local
			l_working_directory: like working_directory
			process: PROCESS
		do
			if working_directory.is_empty then
				l_working_directory := Environment.Execution.current_working_directory
			else
				l_working_directory := working_directory
			end

			accumulated_line.wipe_out
			error_lines.wipe_out
			has_error := False

			argument_list.wipe_out
			argument_list.set_path_encoding (is_path_latin1)
			argument_list.set_default_command_option_prefix
			implementation.set_arguments (Current, argument_list)

			process := process_launcher (program_name, argument_list, l_working_directory)

			process.redirect_output_to_agent (agent on_output (?, False))
			process.redirect_error_to_agent (agent on_output (?, True))

--			process.set_buffer_size (80)

			log_or_io.put_string_field ("Executing", String.abbreviate_working_directory (process.command_line))
			log_or_io.put_new_line

			on_begin
			process.launch
			process.wait_for_exit
			has_error := process.exit_code /= 0

			if has_error then
				log_or_io.put_string ("ERROR: ")
				error_lines.do_all (agent log_or_io.put_line)
			else
				log_or_io.put_string ("OK"); log_or_io.put_new_line
				log_or_io.put_new_line
				on_finish
			end
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

	on_begin
		do
		end

	on_finish
		do
		end

	on_output (buffer: STRING; is_error_output: BOOLEAN)
		local
			lines: LIST [STRING]
		do
			if not buffer.is_empty then
				lines := buffer.split ('%N')
				if lines.count = 1 then
					combine_partial_lines (lines.first, False, is_error_output)
				else
					from lines.start until lines.after loop
						if lines.index < lines.count then
							combine_partial_lines (lines.item, True, is_error_output)
						else
							if lines.item.is_empty then
								combine_partial_lines (once "", True, is_error_output)
							else
								combine_partial_lines (lines.item, False, is_error_output)
							end
						end
						lines.forth
					end
				end
			end
		end

feature {EL_COMMAND_IMPL} -- Implementation

	combine_partial_lines (part: STRING; terminated, is_error_output: BOOLEAN)
		do
			accumulated_line.append (part)
			if terminated then
				accumulated_line.prune_all_trailing ('%R')
				if not accumulated_line.is_empty then
					if is_error_output then
						error_lines.extend (accumulated_line.string)
					else
						do_with_line (accumulated_line.string)
					end
				end
				accumulated_line.wipe_out
			end
		end

	do_with_line (line: STRING)
			--
		do
			log_or_io.put_line (line)
		end

	escaped_argument (path: STRING): STRING
			--
		do
			Result := Environment.Operating.path_escaped_for_shell (path)
		end

	argument_list: EL_COMMAND_ARGUMENT_LIST

	error_lines: ARRAYED_LIST [STRING]

	accumulated_line: STRING

end
