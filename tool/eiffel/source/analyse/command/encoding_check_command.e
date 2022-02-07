note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 6:29:24 GMT (Monday 7th February 2022)"
	revision: "17"

class
	ENCODING_CHECK_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make, execute
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_FILE

	EL_MODULE_DIRECTORY

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (manifest_path: FILE_PATH)
		do
			Precursor (manifest_path)
			create file_encoding_table.make (manifest.file_count)
		end

feature -- Constants

	Description: STRING = "Checks for UTF-8 files that could be encoded as Latin-1"

feature -- Basic operations

	execute
		local
			string_list: EL_STRING_8_LIST; source_path: FILE_PATH
		do
			Precursor
			across file_encoding_table as table loop
				create string_list.make_from_array (table.item.to_array)
				source_path := table.key
				if Directory.current_working.is_parent_of (source_path) then
					source_path := source_path.relative_path (Directory.current_working)
				end
				lio.put_labeled_string (source_path.to_string, string_list.joined (' '))
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			source_32: STRING_32; source_utf_8: STRING
			last_date: INTEGER; source_out: PLAIN_TEXT_FILE
			c: EL_UTF_CONVERTER
		do
			if attached open_lines (source_path, Latin_1) as source_lines then
				if source_lines.encoded_as_utf (8) then
					source_utf_8 := File.plain_text_bomless (source_path)
					if c.is_valid_utf_8_string_8 (source_utf_8) then
						file_encoding_table.extend (source_path, once "UTF-8")
						source_32 := c.utf_8_string_8_to_string_32 (source_utf_8)
						if is_latin_1_encodeable (source_32) then
							file_encoding_table.extend (source_path, once "and Latin-1 encodeable")
							last_date := source_lines.date
							create source_out.make_open_write (source_path)
							source_out.put_string (source_32.to_string_8)
							source_out.close
							source_out.set_date (last_date)
						end
					else
						file_encoding_table.extend (source_path, once "INVALID UTF-8")
					end
					source_lines.close
				end
			end
		end

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

feature {NONE} -- Internal attributes

	file_encoding_table: EL_GROUP_TABLE [STRING, FILE_PATH]

end