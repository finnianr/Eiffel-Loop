note
	description: "Line state machine for [$source STRING_8] lines read from [$source PLAIN_TEXT_FILE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 18:25:57 GMT (Monday 23rd January 2023)"
	revision: "1"

class
	EL_PLAIN_TEXT_FILE_STATE_MACHINE

feature {NONE} -- Initialization

	make
		do
			final := agent (s: STRING) do end
			state := final
		end

feature {NONE} -- Implementation

	call (line: STRING)
		do
			state (line)
		end

	do_with_lines (initial: like final; file_path: FILE_PATH)
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_read (file_path)

			from state := initial until state = final loop
				file.read_line
				if file.end_of_file then
					state := final
				else
					call (file.last_string)
				end
			end
			file.close
		end

feature {NONE} -- Internal attributes

	final: PROCEDURE [STRING]

	state: like final

end