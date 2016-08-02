note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 8:12:49 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	EIFFEL_ENCODING_CHECK_COMMAND

inherit
	EIFFEL_SOURCE_MANIFEST_COMMAND

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_UTF

	EL_MODULE_DIRECTORY

create
	make, default_create

feature -- Basic operations

	process_file (source_path: EL_FILE_PATH)
		local
			source_lines: EL_FILE_LINE_SOURCE; relative_source_path: EL_FILE_PATH
			source_32: STRING_32; source_utf_8: STRING
			last_date: INTEGER; source_out: PLAIN_TEXT_FILE
		do
			create source_lines.make_latin (1, source_path)
			if source_lines.is_utf_8_encoded then
				relative_source_path := source_path.relative_path (Directory.current_working)
				source_utf_8 := File_system.plain_text (source_path)
				source_utf_8.remove_head (3)
				if UTF.is_valid_utf_8_string_8 (source_utf_8) then
					lio.put_new_line
					lio.put_path_field ("UTF-8", relative_source_path)
					source_32 := UTF.utf_8_string_8_to_string_32 (source_utf_8)
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
