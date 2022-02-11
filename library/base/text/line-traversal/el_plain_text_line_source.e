note
	description: "[
		Iterates over lines of a plain text file lines using either the [$source ITERABLE [G]] or
		[$source LINEAR [G]] interface. If a UTF-8 BOM is detected the encoding changes accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-10 20:50:06 GMT (Thursday 10th February 2022)"
	revision: "24"

class
	EL_PLAIN_TEXT_LINE_SOURCE

inherit
	EL_FILE_LINE_SOURCE
		rename
			make as make_from_file,
			encoding as encoding_code
		export
			{ANY} file
		redefine
			open_at_start, make_from_file
		end

	EL_MODULE_FILE
		rename
			File as Mod_file
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

create
	make_default, make, make_from_file, make_utf_8, make_encoded

feature {NONE} -- Initialization

	make_encoded (a_encoding: ENCODING; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_from_file (new_file (Other_class, a_path))
			if not encoding_detected then
				set_other_encoding (a_encoding)
			end
			is_file_external := False -- Causes file to close automatically when after position is reached
		end

	make (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_from_file (new_file (a_encoding, a_path))
			if not encoding_detected then
				set_encoding (a_encoding)
			end
			is_file_external := False -- Causes file to close automatically when after position is reached
		end

	make_from_file (a_file: like file)
		do
			Precursor (a_file)
			if a_file.exists then
				check_encoding
			end
		end

	make_utf_8 (a_path: READABLE_STRING_GENERAL)
		do
			make (Utf_8, a_path)
		end

feature -- Access

	bom_count: INTEGER
		-- byte order mark count

	byte_count: INTEGER
		do
			Result := file.count
		end

	date: INTEGER
		do
			Result := file.date
		end

	file_path: FILE_PATH
		do
			Result := file.path
		end

feature -- Status setting

	delete_file
			--
		do
			if file.is_open_read then
				file.close
			end
			file.delete
		end

	open_at_start
		do
			Precursor
			if bom_count.to_boolean then
				file.go (bom_count)
			end
		end

feature -- Output

	print_first (log: EL_LOGGABLE; n: INTEGER)
		-- print first `n' lines to `log' output with leading tabs expanded to 3 spaces
		local
			line: ZSTRING; tab_count: INTEGER; s: EL_ZSTRING_ROUTINES
		do
			across Current as ln until ln.cursor_index > n loop
				line := ln.item
				tab_count := line.leading_occurrences ('%T')
				if tab_count > 0 then
					line.replace_substring (s.n_character_string (' ', tab_count * 3), 1, tab_count)
				end
				log.put_line (line)
			end
			if not after then
				log.put_line ("..")
			end
		end

feature {NONE} -- Implementation

	check_encoding
		local
			is_open_read: BOOLEAN; c: UTF_CONVERTER
			line_one: STRING
		do
			is_open_read := file.is_open_read
			open_at_start
			if file.count > 0 then
				file.read_line
				line_one := file.last_string
				if line_one.starts_with (c.Utf_8_bom_to_string_8) then
					bom_count := c.Utf_8_bom_to_string_8.count
					encoding_detected := True
					set_utf_encoding (8)
				elseif line_one.starts_with (c.utf_16le_bom_to_string_8) then
					bom_count := c.utf_16le_bom_to_string_8.count
					encoding_detected := True
					set_utf_encoding (16)
				elseif line_one.has_substring (Little_endian_carriage_return) then
					encoding_detected := True
					set_utf_encoding (16)
				end
			end
			if not is_open_read then
				file.close
			end
		end

	new_file (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL): like default_file
		do
			create Result.make_with_name (a_path)
		end

	update_item
		local
			raw_line: STRING
		do
			raw_line := file.last_string
			if encoded_as_utf (16) then -- little endian
				file.read_character -- skip '%U' after '%N'
				raw_line.prune_all_trailing ('%U')
				raw_line.prune_all_trailing ('%R')

			else
				raw_line.prune_all_trailing ('%R')
				if raw_line.has (Unencoded_character) then
					raw_line.prune_all (Unencoded_character) -- Reserved by `EL_ZSTRING' as Unicode placeholder
				end
			end
			if is_shared_item then
				item.wipe_out
			elseif encoded_as_utf (16) then
				create item.make (raw_line.count // 2)
			else
				create item.make (raw_line.count)
			end
			item.append_encoded (raw_line, encoding_code)
		end

feature {NONE} -- Internal attributes

	encoding_detected: BOOLEAN

feature {NONE} -- Constants

	Default_file: PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("default.txt")
		end

	Little_endian_carriage_return: STRING = "%R%U"

end