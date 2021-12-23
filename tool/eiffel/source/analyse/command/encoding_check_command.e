note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-23 10:49:34 GMT (Thursday 23rd December 2021)"
	revision: "11"

class
	ENCODING_CHECK_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

create
	make

feature -- Basic operations

	process_file (source_path: EL_FILE_PATH)
		local
			source_32: STRING_32; source_utf_8: STRING; relative_source_path: EL_FILE_PATH
			last_date: INTEGER; source_out: PLAIN_TEXT_FILE
			c: EL_UTF_CONVERTER
		do
			if attached open_lines (source_path, Latin_1) as source_lines then
				if source_lines.encoded_as_utf (8) then
					relative_source_path := source_path.relative_path (Directory.current_working)
					source_utf_8 := File_system.plain_text_bomless (source_path)
					if c.is_valid_utf_8_string_8 (source_utf_8) then
						lio.put_new_line
						lio.put_path_field ("UTF-8", relative_source_path)
						source_32 := c.utf_8_string_8_to_string_32 (source_utf_8)
						if is_latin_1_encodeable (source_32) then
							lio.put_new_line
							lio.put_path_field ("Latin-1 encodeable", relative_source_path)
							last_date := source_lines.date
							create source_out.make_open_write (source_path)
							source_out.put_string (source_32.to_string_8)
							source_out.close
							source_out.set_date (last_date)
						end
					else
						lio.put_new_line
						lio.put_path_field ("INVALID UTF-8", relative_source_path)
					end
					source_lines.close
				end
			end
		end

feature {NONE} -- Implementation

	is_latin_1_encodeable (source_32: STRING_32): BOOLEAN
		local
			i: INTEGER;
		do
			Result := True
			from i := 1 until not Result or i > source_32.count loop
				if source_32.code (i) > 0xFF then
					Result := False
				end
				i := i + 1
			end
		end

end