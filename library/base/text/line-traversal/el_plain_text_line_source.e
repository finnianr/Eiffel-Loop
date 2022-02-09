note
	description: "[
		Iterates over lines of a plain text file lines using either the [$source ITERABLE [G]] or
		[$source LINEAR [G]] interface. If a UTF-8 BOM is detected the encoding changes accordingly.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 19:03:47 GMT (Wednesday 9th February 2022)"
	revision: "22"

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
	make_default, make, make_from_file, make_utf_8

feature {NONE} -- Initialization

	make_utf_8 (a_path: READABLE_STRING_GENERAL)
		do
			make (Utf_8, a_path)
		end

	make_from_file (a_file: like file)
		do
			Precursor (a_file)
			if a_file.exists then
				check_for_bom
			end
		end

	make (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL)
		-- UTF-8 by default
		do
			make_from_file (new_file (a_encoding, a_path))
			if not has_utf_8_bom then
				set_encoding (a_encoding)
			end
			is_file_external := False -- Causes file to close automatically when after position is reached
		end

feature -- Access

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

feature -- Status query

	has_utf_8_bom: BOOLEAN
		-- True if file has UTF-8 byte order mark		

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
			if has_utf_8_bom then
				file.go (3)
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

	check_for_bom
		local
			is_open_read: BOOLEAN
		do
			is_open_read := file.is_open_read
			open_at_start
			has_utf_8_bom := Mod_file.has_utf_8_bom_marker (file)
			if has_utf_8_bom then
				set_utf_encoding (8)
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
			raw_line.prune_all_trailing ('%R')
			if raw_line.has (Unencoded_character) then
				raw_line.prune_all (Unencoded_character) -- Reserved by `EL_ZSTRING' as Unicode placeholder
			end
			if is_shared_item then
				item.wipe_out
			else
				create item.make (raw_line.count)
			end
			item.append_encoded (raw_line, encoding_code)
		end

feature {NONE} -- Constants

	Default_file: PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("default.txt")
		end

end