note
	description: "Checks for UTF-8 files that could be encoded as Latin-1"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-16 11:46:21 GMT (Saturday 16th September 2023)"
	revision: "20"

class
	ENCODING_CHECK_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			execute, make_default, read_manifest_files
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_FILE

	EL_MODULE_DIRECTORY

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor
			create file_encoding_table.make (0)
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
			source_text: STRING; last_date: INTEGER; source_out: PLAIN_TEXT_FILE
			utf: EL_UTF_CONVERTER
		do
			source_text := File.raw_plain_text (source_path)
			if utf.is_utf_8_file (source_text) then
				if attached utf.bomless_utf_8 (source_text) as source_utf_8
					and then utf.is_valid_utf_8_string_8 (source_utf_8)
				then
					file_encoding_table.extend (source_path, once "UTF-8")
					if attached utf.utf_8_string_8_to_string_32 (source_utf_8) as source_32
						and then source_32.is_valid_as_string_8
					then
						file_encoding_table.extend (source_path, once "and Latin-1 encodeable")
						last_date := File.modification_time (source_path)
						create source_out.make_open_write (source_path)
						source_out.put_string (source_32.to_string_8)
						source_out.close
						source_out.set_date (last_date)
					end
				else
					file_encoding_table.extend (source_path, once "INVALID UTF-8")
				end
			end
		end

	read_manifest_files
		do
			Precursor
			file_encoding_table.accommodate (manifest.file_count)
		end

feature {NONE} -- Internal attributes

	file_encoding_table: EL_GROUP_TABLE [STRING, FILE_PATH]

end