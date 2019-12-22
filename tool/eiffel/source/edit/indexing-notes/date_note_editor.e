note
	description: "Date note editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 11:58:19 GMT (Sunday 22nd December 2019)"
	revision: "2"

class
	DATE_NOTE_EDITOR

inherit
	NOTE_EDITOR
		redefine
			edit
		select
			edit
		end

	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		rename
			edit as file_edit
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Basic operations

	edit
		local
			notes: CLASS_NOTES; is_revised: BOOLEAN
		do
			reset
			create notes.make (input_lines, default_values)
			across notes.original_lines as line until is_revised loop
				if line.item.starts_with (Date_line_start) and then is_misformed (line.item) then
					correct (line.item)
					is_revised := True
				end
			end
			if is_revised then
				output_lines.append (notes.original_lines)
				file_edit
				File_system.set_file_stamp (file_path, notes.last_time_stamp)
				lio.put_new_line
				lio.put_labeled_string ("Fixed", file_path.base)
				lio.put_new_line
			else
				input_lines.close
			end
		end

feature {NONE} -- Implementation

	is_misformed (line: ZSTRING): BOOLEAN
		do
			Result := line.occurrences (' ') > 6
		end

	correct (line: ZSTRING)
		do
			line.replace_substring_all (n_character_string (' ', 2), character_string (' '))
		end

feature {NONE} -- Constants

	Date_line_start: ZSTRING
		once
			Result := "%Tdate:"
		end

end
