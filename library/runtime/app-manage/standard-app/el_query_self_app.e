note
	description: "[
		Stanard application to list all running instances of current application with
		it's command line and process ID
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-08 14:43:41 GMT (Saturday 8th March 2025)"
	revision: "1"

class
	EL_QUERY_SELF_APP

inherit
	EL_APPLICATION

create
	default_create

feature {NONE} -- Initiliazation

	initialize
			--
		do
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
				line.remove_head (Truncated_app_name.count + 1)
				index := line.substring_index (Executable.name, 1)
				if index > 1 then
				-- remove absolute path directory
					line.remove_head (index - 1)
				end
				lio.put_labeled_string ("PID", pid)
				lio.put_spaces (1)
				lio.put_line (line)
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

	Truncated_app_name: ZSTRING
		once
			Result := Executable.name.twin
			Result.keep_head (15)
		end

	Description: STRING = "List all running instances of current application"

end