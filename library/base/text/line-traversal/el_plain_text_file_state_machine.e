note
	description: "Line state machine for [$source STRING_8] lines read from [$source PLAIN_TEXT_FILE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-24 19:11:35 GMT (Tuesday 24th January 2023)"
	revision: "2"

class
	EL_PLAIN_TEXT_FILE_STATE_MACHINE

inherit
	EL_STATE_MACHINE [STRING]

feature {NONE} -- Implementation

	do_with_lines (initial: like final; file_path: FILE_PATH)
		local
			file: PLAIN_TEXT_FILE; l_final: like final
		do
			item_number := 0; l_final := final
			create file.make_open_read (file_path)

			from state := initial until state = l_final loop
				file.read_line
				if file.end_of_file then
					state := final
				else
					item_number := item_number + 1
					call (file.last_string)
				end
			end
			file.close
		end

end