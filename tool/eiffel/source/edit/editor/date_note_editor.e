note
	description: "Date note editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:13:04 GMT (Monday 5th December 2022)"
	revision: "11"

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

create
	make

feature -- Basic operations

	edit
		local
			notes: CLASS_NOTE_EDITOR; is_revised: BOOLEAN
		do
			reset
			create notes.make (input_lines, default_values)
			across notes.original_lines as line until is_revised loop
				if line.item.starts_with_zstring (Date_line_start) and then is_misformed (line.item) then
					correct (line.item)
					is_revised := True
				end
			end
			if is_revised then
				output_lines.append (notes.original_lines)
				file_edit
				File.set_stamp (source_path, notes.last_time_stamp)
				command.report ("Fixed", source_path.base)
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
		local
			s: EL_ZSTRING_ROUTINES
		do
			line.replace_substring_all (s.n_character_string (' ', 2), s.character_string (' '))
		end

feature {NONE} -- Constants

	Date_line_start: ZSTRING
		once
			Result := "%Tdate:"
		end

end