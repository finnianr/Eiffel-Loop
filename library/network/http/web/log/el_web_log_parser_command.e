note
	description: "Web log parser command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 8:15:04 GMT (Friday 13th September 2024)"
	revision: "10"

deferred class
	EL_WEB_LOG_PARSER_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_ITERATION_OUTPUT

	EL_FILE_OPEN_ROUTINES

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: FILE_PATH)
		do
			log_path := a_log_path
		end

feature -- Basic operations

	execute
		local
			count: INTEGER
		do
			reset_dot_count
			default_entry.reset_cache
			if is_lio_enabled then
				lio.put_labeled_string ("Reading log entries", log_path.base)
				lio.put_new_line
			end
			if attached open_lines (log_path, Latin_1) as line_source then
				across line_source as line loop
					print_progress (line.cursor_index.to_natural_32)
					if line.shared_item.occurrences ('%"') = 6 then
						do_with (new_web_log_entry (line.shared_item))
						count := count + 1
					end
				end
				line_source.close
			end
			if is_lio_enabled then
				lio.put_new_line
				lio.put_integer_field ("Total entries", count)
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Implementation

	default_entry: EL_WEB_LOG_ENTRY
		do
			create Result.make_default
		end

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