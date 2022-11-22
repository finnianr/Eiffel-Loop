note
	description: "[
		Plain text file encoded as UTF-8 by default
		By default it does not write a byte-order mark unless `is_bom_enabled' is set to `True'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 13:30:16 GMT (Tuesday 22nd November 2022)"
	revision: "9"

class
	EL_PLAIN_TEXT_FILE

inherit
	PLAIN_TEXT_FILE
		rename
			put_string as put_raw_string_8,
			put_character as put_raw_character_8,
			path as ise_path,
			last_string as last_string_8,
			read_line as read_line_8
		redefine
			make_with_name, make_with_path, open_read
		end

	EL_OUTPUT_MEDIUM
		redefine
			make_default
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

	EL_MODULE_ENCODING
		rename
			Encoding as Mod_encoding
		end

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

feature -- Access

	bom_count: INTEGER
		-- byte order mark count

	last_string: ZSTRING

	lines: EL_PLAIN_TEXT_LINE_SOURCE
		do
			create Result.make_from_file (Current)
		end

	path: EL_FILE_PATH
		do
			create Result.make (internal_name)
		end

feature -- Status query

	encoding_detected: BOOLEAN

feature -- Status setting

	open_read
		do
			Precursor
			encoding_detected := False
			if byte_order_mark.is_enabled and then attached Mod_encoding.file_info (Current) as info then
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
					read_character -- skip '%U' after '%N'
					raw_line.prune_all_trailing ('%U')
					raw_line.prune_all_trailing ('%R')

				else
					raw_line.prune_all_trailing ('%R')
					if raw_line.has (Substitute) then
						raw_line.prune_all (Substitute) -- Reserved by `EL_ZSTRING' as Unicode placeholder
					end
				end
				last_string.wipe_out
				if encoding_type = Other_class then
					last_string.append_encoded_any (raw_line, other_encoding)
				else
					last_string.append_encoded (raw_line, encoding)
				end
			end
		end
end