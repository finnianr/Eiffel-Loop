note
	description: "[
		Fix note fields where the characters `: "[' where being replaced with some bad bytes.
	]"
	notes: "[
		This was due to a bug in ${VERBATIM_NOTE_FIELD} caused by changing `name' to
		${IMMUTABLE_STRING_8} type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 11:06:31 GMT (Saturday 5th October 2024)"
	revision: "1"

class
	FIX_BAD_NOTE_FIELDS_COMMAND

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make_default
		end

	EL_MODULE_FILE

	NOTE_CONSTANTS

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make_default
		do
			Precursor
			progress_tracking.disable
		end

feature -- Constants

	Description: STRING = "Fix corruption of note fields from VERBATIM_NOTE_FIELD bug"

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			source_text, notes_section, declaration, class_name, bad_bytes_string, correct_bytes: STRING
			index: INTEGER; is_windows: BOOLEAN
		do
			source_text := File.raw_plain_text (source_path)
			is_windows := File.has_windows_line_break (source_text)
			bad_bytes_string := bad_bytes_array [is_windows.to_integer]
			class_name := source_path.base_name
			class_name.to_upper
			declaration := Tab_prefix + class_name
			index := source_text.substring_index (declaration, 1)
			if index > 0 then
				notes_section := source_text.substring (1, index - 1)
				if notes_section.has_substring (bad_bytes_string) then
					if is_windows then
						lio.put_labeled_string ("Bad Windows class", class_name)
					else
						lio.put_labeled_string ("Bad Unix class", class_name)
					end
					lio.put_new_line
					correct_bytes := Corrected_insert
					correct_bytes.keep_head (4); correct_bytes.append_character ('%N')
					if is_windows then
						correct_bytes.insert_character ('%R', correct_bytes.count)
					end
					notes_section.replace_substring_all (bad_bytes_string, correct_bytes)
					lio.put_string (notes_section)
					lio.put_new_line_x2
					if attached new_note_date (notes_section) as note_date then
						source_text.replace_substring (notes_section, 1, index - 1)
						File.write_text (source_path, source_text)
						File.set_stamp (source_path, new_note_date (notes_section).time_stamp)
					end
				end
			end
		end

	new_note_date (notes_section: STRING): NOTE_DATE_TIME
		local
			date_time: detachable NOTE_DATE_TIME; quote_index, index: INTEGER
		do
			index := notes_section.substring_index (Date_pattern, 1)
			if index > 0 then
				index := index + Date_pattern.count
				quote_index := notes_section.index_of ('"', index)
				if quote_index > 0 then
					create date_time.make (notes_section.substring (index, quote_index))
				end
			end
			if attached date_time as dt then
				Result := dt
			else
				create Result.make_default
			end
		end

feature {NONE} -- Internal attributes

	Tab_prefix: STRING = "%T"

	Corrected_insert: STRING = ": %"["

	Bad_bytes_array: SPECIAL [STRING]
		-- Unix and Windows
		local
			str: STRING
		once
			str := "%U%/4/%U%/4/%N"
			create Result.make_filled (str, 2)
		-- Windows variant
			str := str.twin
			str.insert_character ('%R', str.count)
			Result [1] := str
		end

end