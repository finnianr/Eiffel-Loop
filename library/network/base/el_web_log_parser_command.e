note
	description: "Web log parser command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-03 10:45:11 GMT (Saturday 3rd August 2019)"
	revision: "1"

deferred class
	EL_WEB_LOG_PARSER_COMMAND

inherit
	EL_COMMAND

	EL_ITERATION_OUTPUT

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: EL_FILE_PATH)
		do
			log_path := a_log_path
		end

feature -- Basic operations

	execute
		local
			line_source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			dot_count := 0
			create line_source.make (log_path)
			across line_source as line loop
				print_progress (line.cursor_index.to_natural_32)
				if line.item.occurrences ('%"') = 6 then
					do_with (new_web_log_entry (line.item))
				end
			end
			line_source.close
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

	log_path: EL_FILE_PATH

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 100
		end

end
