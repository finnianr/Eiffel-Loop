note
	description: "Web log parser command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-05 15:06:35 GMT (Sunday 5th June 2022)"
	revision: "5"

deferred class
	EL_WEB_LOG_PARSER_COMMAND

inherit
	EL_COMMAND

	EL_ITERATION_OUTPUT

	EL_FILE_OPEN_ROUTINES

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: FILE_PATH)
		do
			log_path := a_log_path
		end

feature -- Basic operations

	execute
		do
			dot_count := 0
			if attached open_lines (log_path, Utf_8) as line_source then
				across line_source as line loop
					print_progress (line.cursor_index.to_natural_32)
					if line.item.occurrences ('%"') = 6 then
						do_with (new_web_log_entry (line.item))
					end
				end
				line_source.close
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	do_with (entry: like new_web_log_entry)
		deferred
		end

	new_web_log_entry (line: ZSTRING): EL_WEB_LOG_ENTRY
		do
			create Result.make (line)
		end

feature {NONE} -- Internal attributes

	log_path: FILE_PATH

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 100
		end

end