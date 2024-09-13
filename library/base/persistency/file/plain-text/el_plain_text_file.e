note
	description: "[
		Plain text file encoded as UTF-8 by default
		By default it does not write a byte-order mark unless `is_bom_enabled' is set to `True'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 16:50:41 GMT (Friday 13th September 2024)"
	revision: "16"

class
	EL_PLAIN_TEXT_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			put_string as put_encoded_string_8,
			put_character as put_encoded_character_8,
			path as ise_path,
			last_string as last_string_8,
			read_line as read_line_8
		redefine
			make_with_name, make_with_path, open_read
		end

	EL_OUTPUT_MEDIUM
		rename
			encoding as file_encoding
		redefine
			make_default
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

	EL_MODULE_ENCODING; EL_MODULE_FILE

create
	make, make_with_name, make_with_path, make_closed,
	make_open_read, make_open_write, make_open_append,
	make_open_read_write, make_create_read_write,
	make_open_read_append

feature {NONE} -- Initialization

	make_closed
		do
			make_with_name ("closed.txt")
		end

	make_default
		do
			Precursor
			create last_string.make_empty
		end

	make_with_name (fn: READABLE_STRING_GENERAL)
			-- Create file object with `fn' as file name.
		do
			Precursor (fn)
			make_default
		end

	make_with_path (a_path: PATH)
		do
			Precursor (a_path)
			make_default
		end

feature -- Measurement

	average_line_count: INTEGER
		-- average characters per line based on leading 1K block
		-- (optimized so as not to call `last_character')
		require
			readable: readable
		local
			previous_pos, char_count, newline_count: INTEGER; pending_break, break: BOOLEAN
			c: CHARACTER; utf_encoded: BOOLEAN; utf_lines: STRING; f_pointer: POINTER
		do
			previous_pos := position
			if bom_count > 0 then
				go (bom_count)
			else
				go (0)
			end
			if is_utf_encoded then
				create utf_lines.make (1024 + 100)
				utf_encoded := True
			else
				utf_lines := Empty_string_8
			end
			from f_pointer := file_pointer until break loop
				c := file_gc (f_pointer)
				if file_feof (f_pointer) then
				-- NOTE: `c.natural_code = 0xFF' for `end_of_file' condition
					break := True
				else
					inspect c
						when '%N' then
							newline_count := newline_count + 1
							if pending_break then
								break := True
							end
					else
					end
					if utf_encoded then
						utf_lines.extend (c)
					end
					char_count := char_count + 1
					if char_count > 1024 then
						pending_break := True
					end
				end
			end
			if utf_encoded then
				char_count := unicode_count (utf_lines)
			end
			Result := (char_count / newline_count.max (1)).rounded
			go (previous_pos)
		ensure
			position_unchanged: position = old position
		end

	bom_count: INTEGER
		-- byte order mark count

feature -- Access

	last_string: ZSTRING

	lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make_from_file (Current)
		end

	path: EL_FILE_PATH
		do
			create Result.make (internal_name)
		end

	string_8_lines: EL_ITERABLE_SPLIT [STRING, ANY]
		do
			Result := File.plain_text_lines (path)
		end

feature -- Status query

	encoding_detected: BOOLEAN

feature -- Status setting

	open_read
		do
			Precursor
			encoding_detected := False
			if byte_order_mark.is_enabled and then attached Encoding.file_info (Current) as info then
				bom_count := info.bom_count
				encoding_detected := info.detected
				if encoding_detected then
					set_encoding (info.encoding)
				end
			else
				bom_count := 0
			end
			if bom_count > 0 then
				go (bom_count)
			end
		end

feature -- Basic operations

	read_line
		do
			read_line_8
			if attached last_string_8 as raw_line then
				if encoded_as_utf (16) then -- little endian
					if not end_of_file then
						read_character -- skip '%U' after '%N'
					end
					raw_line.prune_all_trailing ('%U')
					raw_line.prune_all_trailing ('%R')
				else
					raw_line.prune_all_trailing ('%R')
					if raw_line.has (Substitute) then
						raw_line.prune_all (Substitute) -- Reserved by `EL_ZSTRING' as Unicode placeholder
					end
				end
				last_string.wipe_out

				if encoding_type = Other_class and then attached encoding_other as l_encoding then
					last_string.append_encoded_any (raw_line, l_encoding)
				else
					last_string.append_encoded (raw_line, file_encoding)
				end
			end
		end

feature {NONE} -- Implementation

	unicode_count (utf_lines: STRING): INTEGER
		local

			utf_16_le: EL_UTF_16_LE_CONVERTER; utf_8_converter: EL_UTF_8_CONVERTER
		do
			inspect file_encoding
				when Utf_8 then
					Result := utf_8_converter.unicode_count (utf_lines)
				when Utf_16 then
					Result := utf_16_le.unicode_count (utf_lines)
			else
			end
		end
end