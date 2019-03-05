note
	description: "Process file lines using using either the `ITERABLE' or `LINEAR' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-04 21:23:37 GMT (Monday 4th March 2019)"
	revision: "7"

class
	EL_PLAIN_TEXT_LINE_SOURCE

inherit
	EL_PLAIN_TEXT_LINE_SOURCE_I
		rename
			make as make_from_file,
			make_latin_1 as make_latin_1_encoding
		export
			{ANY} file
		redefine
			make_default, open_at_start
		end

	EL_ZCODEC_FACTORY

create
	make_default, make, make_encoded, make_latin, make_from_file, make_windows

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH)
		-- UTF-8 by default
		do
			make_from_file (create {like file}.make_with_name (a_file_path))
			check_for_bom
			is_file_external := False -- Causes file to close automatically when after position is reached
		end

	make_default
			--
		do
			Precursor
			update_codec
			encoding_change_actions.extend (agent update_codec)
		end

	make_encoded (encoding: EL_ENCODING_BASE; a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			if not has_utf_8_bom then
				set_encoding_from_other (encoding)
			end
		end

	make_latin (a_encoding: INTEGER; a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			if not has_utf_8_bom then
				set_latin_encoding (a_encoding)
			end
		end

	make_windows (a_encoding: INTEGER; a_file_path: EL_FILE_PATH)
		do
			make (a_file_path)
			if not has_utf_8_bom then
				set_windows_encoding (a_encoding)
			end
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

	file_path: EL_FILE_PATH
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

feature {NONE} -- Implementation

	check_for_bom
		local
			is_open_read: BOOLEAN
		do
			is_open_read := file.is_open_read
			open_at_start
			if file.count >= 3 then
				file.read_stream (3)
				has_utf_8_bom := file.last_string ~ {UTF_CONVERTER}.Utf_8_bom_to_string_8
				if has_utf_8_bom then
					set_utf_encoding (8)
				end
			end
			if not is_open_read then
				file.close
			end
		end

	update (line: like item)
		local
			raw_line: STRING
		do
			line.wipe_out
			raw_line := file.last_string
			raw_line.prune_all_trailing ('%R')
			if line.encoded_with (codec) then
				raw_line.prune_all ('%/026/') -- Reserved by `EL_ZSTRING' as Unicode placeholder
				line.append_raw_string_8 (raw_line)
			else
				line.append_string_general (codec.as_unicode (raw_line, False))
			end
		end

	update_codec
		do
			codec := new_codec (Current)
		end

feature {NONE} -- Internal attributes

	codec: EL_ZCODEC

feature {NONE} -- Constants

	Default_file: PLAIN_TEXT_FILE
		once
			create Result.make_with_name ("default.txt")
		end

end
