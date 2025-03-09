note
	description: "[
		Standard application to list all running instances of current application with
		it's command line and process ID
	]"
	notes: "[
		Usage:
		
			<app-name> -query_self
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-09 9:20:22 GMT (Sunday 9th March 2025)"
	revision: "2"

class
	EL_QUERY_SELF_APP

inherit
	EL_APPLICATION
		redefine
			is_valid_platform
		end

create
	default_create

feature {NONE} -- Initiliazation

	initialize
			--
		do
		end

feature -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature -- Basic operations

	run
		local
			process_list_cmd: EL_CAPTURED_OS_COMMAND
		do
			create process_list_cmd.make_with_name ("process_list", "ps -eo pid,comm")
			process_list_cmd.execute
			if attached process_list_cmd.lines.query_if (agent is_application) as process_list then
				if process_list.count = 1 then
					lio.put_line ("Only this application is running")
				else
					across process_list as list loop
						if attached list.item as line then
							line.left_adjust
							display_process (line, line.substring_to (' '))
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	display_process (a_line: ZSTRING; pid: STRING)
		local
			process_info_cmd: EL_CAPTURED_OS_COMMAND; index: INTEGER
		do
			create process_info_cmd.make_with_name ("process_info", "ps -o comm,args= -p " + pid)
			process_info_cmd.execute
			if attached process_info_cmd.lines as line_list and then line_list.count = 2
				and then attached line_list.last as line
				and then not line.ends_with_general (option_name)
			then
				lio.put_labeled_string ("PID", pid)
				lio.put_spaces (1)
				index := line.substring_index (Executable.name, Max_name_count + 1)
				if index > 0 then
				-- remove absolute path directory
					lio.put_line (line.substring_end (index + Executable.name.count + 1))
				end
			end
		end

	is_application (line: ZSTRING): BOOLEAN
		do
			if line.has_substring ("servlet") then
				do_nothing
			end
			Result := line.ends_with (Truncated_app_name)
		end

feature {NONE} -- Constants

	Description: STRING = "List all running instances of current application"

	Max_name_count: INTEGER = 15
		-- maximum length of application name output by pscommand

	Truncated_app_name: ZSTRING
		once
			Result := Executable.name
			if Result.count > Max_name_count then
				Result := Result.substring (1, Max_name_count)
			end
		end

end