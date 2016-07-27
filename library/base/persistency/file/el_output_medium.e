note
	description: "Summary description for {EL_TEXT_INDENTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-05 17:26:41 GMT (Tuesday 5th July 2016)"
	revision: "6"

deferred class
	EL_OUTPUT_MEDIUM

inherit
	EL_ENCODEABLE_AS_TEXT
		redefine
			set_encoding
		end

	EL_SHARED_ZCODEC_FACTORY

	STRING_HANDLER

	EL_MODULE_UTF

	EL_SHARED_ONCE_STRINGS

feature -- Access

	position: INTEGER
		deferred
		end

feature -- Output

	put_bom
			-- put utf-8 byte order mark for UTF-8 encoding
		require
			start_of_file: position = 0
		do
			if is_bom_writeable then
				put_encoded_string_8 (UTF.Utf_8_bom_to_string_8)
			end
		end

	put_lines (lines: CHAIN [READABLE_STRING_GENERAL])
		do
			if position = 0 then
				put_bom
			end
			from lines.start until lines.after loop
				if lines.index > 1 then
					put_new_line
				end
				put_string (lines.item)
				lines.forth
			end
		end

	put_indented_lines (indent: STRING; lines: LINEAR [READABLE_STRING_GENERAL])
		require
			valid_indent: across indent as c all c.item = '%T' or else c.item = ' ' end
		do
			if position = 0 then
				put_bom
			end
			from lines.start until lines.after loop
				put_encoded_string_8 (indent); put_string (lines.item)
				put_new_line
				lines.forth
			end
		end

	put_character (c: CHARACTER)
		deferred
		end

	put_encoded_string_8 (str: STRING)
		deferred
		end

	put_integer (n: INTEGER)
		deferred
		end

	put_new_line
		deferred
		end

	put_natural (n: NATURAL)
		deferred
		end

	put_string (str: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} str as str_z then
				put_string_z (str_z)
			elseif attached {STRING} str as str_8 then
				put_string_8 (str_8)
			elseif attached {STRING_32} str as str_32 then
				put_string_32 (str_32)
			end
		end

	put_string_8, put_latin_1 (str: STRING)
		local
			utf_8: STRING
		do
			-- Assume STRING types are either latin-1 or utf-8
			if encoding_type = Encoding_iso_8859 and encoding = 1 then
				put_encoded_string_8 (str)
			elseif encoding_type = Encoding_utf and encoding = 8 then
				utf_8 := empty_once_string_8
				UTF.utf_32_string_into_utf_8_string_8 (str, utf_8)
				put_encoded_string_8 (utf_8)
			else
				-- Some other latin encoding
				put_string_32 (str)
			end
		end

	put_string_32 (str_32: STRING_32)
		local
			encoded_string: STRING; extendible_unencoded: like Once_extendible_unencoded
		do
			encoded_string := empty_once_string_8
			if encoding_type = Encoding_utf and encoding = 8 then
				UTF.utf_32_string_into_utf_8_string_8 (str_32, encoded_string)
			else
				extendible_unencoded := Once_extendible_unencoded
				extendible_unencoded.wipe_out
				encoded_string.grow (str_32.count)
				encoded_string.set_count (str_32.count)
				codec.encode (str_32, encoded_string.area, 0, extendible_unencoded)
			end
			put_encoded_string_8 (encoded_string)
		end

	put_string_z (str: ZSTRING)
		require
			valid_encoding: str.has_mixed_encoding implies encoding_type = Encoding_utf and encoding = 8
		do
			if encoding_type = Encoding_utf then
				put_encoded_string_8 (str.to_utf_8)
			else
				if str.encoded_with (codec) then
					put_encoded_string_8 (str.to_latin_string_8)
				else
					put_string_32 (str.to_unicode)
				end
			end
		end

feature -- Element change

	set_encoding (a_type: like encoding_type a_encoding: like encoding)
			--
		do
			Precursor (a_type, a_encoding)
			if encoding_type = Encoding_ISO_8859 then
				codec := new_iso_8859_codec (encoding)

			elseif encoding_type = Encoding_windows then
				codec := new_windows_codec (encoding)

			elseif encoding_type = Encoding_utf then
				create {EL_ISO_8859_1_ZCODEC} codec.make
			end
		end

	set_latin_1_encoding
		do
			set_encoding (Encoding_iso_8859, 1)
		end

feature -- Status change

	enable_bom
		do
			is_bom_enabled := True
		end

	disable_bom
		do
			is_bom_enabled := False
		end

feature -- Status query

	is_open_write: BOOLEAN
		deferred
		end

	is_writable: BOOLEAN
		deferred
		end

	is_bom_writeable: BOOLEAN
		do
			Result := is_bom_enabled and then (encoding_type = Encoding_utf and encoding = 8)
		end

	is_bom_enabled: BOOLEAN
		-- True if UTF-8 byte-order-mark writing is enabled

feature -- Basic operations

	close
		deferred
		end

	open_write
		deferred
		end

	open_read
		deferred
		end

feature {NONE} -- Implementation

	codec: EL_ZCODEC
end