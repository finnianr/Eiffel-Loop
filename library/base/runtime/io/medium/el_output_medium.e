note
	description: "Encoded text medium"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-17 13:57:44 GMT (Monday 17th March 2025)"
	revision: "44"

deferred class
	EL_OUTPUT_MEDIUM

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

	EL_WRITABLE
		rename
			write_any as put_any,
			write_encoded_character_8 as put_encoded_character_8, -- Allows UTF-8 conversion
			write_encoded_string_8 as put_encoded_readable_string_8,

			write_character_8 as put_character_8,
			write_character_32 as put_character_32,
			write_integer_8 as put_integer_8,
			write_integer_16 as put_integer_16,
			write_integer_32 as put_integer_32,
			write_integer_64 as put_integer_64,
			write_natural_8 as put_natural_8,
			write_natural_16 as put_natural_16,
			write_natural_32 as put_natural_32,
			write_natural_64 as put_natural_64,
			write_real_32 as put_real,
			write_real_64 as put_double,
			write_string as put_string,
			write_string_8 as put_string_8,
			write_string_32 as put_string_32,
			write_string_general as put_string_general,
			write_boolean as put_boolean,
			write_pointer as put_pointer
		redefine
			put_string_general
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_IMP
		rename
			is_character as is_string_character,
			occurrences as string_occurrences
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS; EL_ZSTRING_CONSTANTS

	EL_SHARED_ENCODINGS; EL_SHARED_ZCODEC_FACTORY; EL_SHARED_STRING_8_BUFFER_POOL

feature {NONE} -- Initialization

	make_default
		do
			create byte_order_mark
			Precursor
			set_codec
			on_encoding_change.add_action (agent set_codec)
		end

feature -- Access

	position: INTEGER
		deferred
		end

feature -- Output

	put_character_32 (c: CHARACTER_32)
		do
			inspect encoding
				when Other_class then
					One_character [1] := c
					put_other (One_character)

				when Latin_1 then
					if c.is_character_8 then
						put_encoded_character_8 (c.to_character_8)
					else
						put_encoded_character_8 ({EL_ZCODE_CONVERSION}.Substitute)
					end
			else
				codec.write_encoded_character (c, Current)
			end
		end

	put_character_8 (c: CHARACTER)
		do
			inspect encoding
				when Other_class then
					One_character [1] := c
					put_other (One_character)

				when Latin_1 then
					put_encoded_character_8 (c)
			else
				codec.write_encoded_character (c, Current)
			end
		end

	put_new_line
		deferred
		end

	put_new_line_x2
		do
			put_new_line; put_new_line
		end

	put_pointer (p: POINTER)
		do
			put_encoded_string_8 (p.out)
		end

feature -- String output

	force_bom
		do
			put_encoded_string_8 ({UTF_CONVERTER}.Utf_8_bom_to_string_8) -- 0xEF,0xBB,0xBF
		end

	put_bom
		-- put utf-8 byte order mark for UTF-8 encoding
		require
			start_of_file: position = 0
		do
			if is_bom_writeable then
				force_bom
			end
		end

	put_indent (tab_count: INTEGER)
		local
			i: INTEGER
		do
			from i := 1 until i > tab_count loop
				put_encoded_character_8 ('%T')
				i := i + 1
			end
		end

	put_indented_line (tab_count: INTEGER; line: READABLE_STRING_GENERAL)
		do
			put_indent (tab_count); put_string_general (line)
			put_new_line
		end

	put_indented_lines (indent: STRING; lines: ITERABLE [READABLE_STRING_GENERAL])
		require
			valid_indent: across indent as c all c.item = '%T' or else c.item = ' ' end
		local
			not_first: BOOLEAN
		do
			if position = 0 then
				put_bom
			end
			across lines as line loop
				if not_first then
					put_new_line
				else
					not_first := True
				end
				if not indent.is_empty then -- Necessary for Network stream
					put_encoded_string_8 (indent)
				end
				put_string_general (line.item)
			end
		end

	put_line (line: READABLE_STRING_GENERAL)
		do
			put_string_general (line)
			put_new_line
		end

	put_lines (lines: ITERABLE [READABLE_STRING_GENERAL])
		do
			put_indented_lines (Empty_string_8, lines)
		end

	put_encoded_string_8 (str: STRING_8)
		-- write encoded string (usually UTF-8)
		deferred
		end

	put_encoded_readable_string_8 (str: READABLE_STRING_8)
		do
			put_encoded_string_8 (str.to_string_8)
		end

	put_string (str: EL_READABLE_ZSTRING)
		require else
			valid_encoding: str.has_mixed_encoding implies encoded_as_utf (8)
		do
			inspect encoding
				when Utf_8 then
					str.write_utf_8_to (Current)

				when Other_class then
					put_string_general (str)
			else
				if str.encoded_with (codec) then
					if attached String_8_pool.borrowed_item as borrowed then
						put_encoded_string_8 (borrowed.copied (str.to_shared_immutable_8))
						borrowed.return
					end
				else
					put_codec_encoded (str)
				end
			end
		end

	put_string_32 (str: READABLE_STRING_32)
		require else
			valid_encoding: not str.is_valid_as_string_8 implies encoded_as_utf (8)
		do
			inspect encoding
				when Utf_8 then
					shared_cursor (str).write_utf_8_to (Current)

				when Other_class then
					put_other (str)
			else
				if is_zstring (str) and then attached {ZSTRING} str as z_str then
					put_string (z_str)
				else
					put_codec_encoded (str)
				end
			end
		end

	put_string_8, put_latin_1 (str: READABLE_STRING_8)
		do
			inspect encoding
				when Utf_8 then
					shared_cursor_8 (str).write_utf_8_to (Current)

				when Other_class then
					put_string_general (str)

				when Latin_1 then
					put_encoded_readable_string_8 (str)
			else
				put_codec_encoded (str)
			end
		end

	put_string_general (str: READABLE_STRING_GENERAL)
		require else
			valid_encoding: not str.is_valid_as_string_8 implies encoded_as_utf (8)
		do
			inspect encoding
				when Other_class then
					put_other (str)

				when Utf_8 then
					shared_cursor (str).write_utf_8_to (Current)
			else
				if str.is_string_8 and then attached {READABLE_STRING_8} str as str_8 then
					put_string_8 (str_8)

				elseif is_zstring (str) and then attached {ZSTRING} str as z_str then
					put_string (z_str)

				else
					put_codec_encoded (str)
				end
			end
		end

feature -- Status query

	byte_order_mark: EL_BOOLEAN_OPTION
		-- writes a UTF-8 byte-order-mark when enabled

	is_bom_writeable: BOOLEAN
		do
			Result := byte_order_mark.is_enabled and then encoded_as_utf (8)
		end

	is_open_write: BOOLEAN
		deferred
		end

	is_writable: BOOLEAN
		deferred
		end

feature -- Basic operations

	close
		deferred
		end

	open_read
		deferred
		end

	open_write
		deferred
		end

feature {NONE} -- Implementation

	put_codec_encoded (str: READABLE_STRING_GENERAL)
		require
			not_utf_8: not codec.is_utf_encoded
		do
			if attached String_8_pool.sufficient_item (str.count) as borrowed then
				if attached borrowed.sized (str.count) as str_8 then
					codec.encode_as_string_8 (str, str_8.area, 0)
					put_encoded_string_8 (str_8)
				end
				borrowed.return
			end
		end

feature {NONE} -- Implementation

	put_other (str: READABLE_STRING_GENERAL)
		require
			encoding_class_other: encoding = Other_class
		local
			l_encoding: ENCODING; done: BOOLEAN
		do
			if attached Encodings.Unicode as unicode then
				-- Fix for bug where LANG=C in Nautilus F10 terminal caused a crash
				if attached encoding_other as other then
					l_encoding := other
				else
					l_encoding := Encodings.Utf_8
				end
				from until done loop
					if attached {EL_READABLE_ZSTRING} str as zstr then
						unicode.convert_to (l_encoding, zstr.to_general)
					else
						unicode.convert_to (l_encoding, str)
					end
					if unicode.last_conversion_successful then
						done := True
					else
						l_encoding := Encodings.Utf_8
					end
				end
				put_encoded_string_8 (unicode.last_converted_string_8)
			end
		end

	set_codec
			--
		do
			if Codec_factory.has_codec (Current) then
				codec := Codec_factory.codec (Current)
			else
				codec := Codec_factory.codec_by (Utf_8)
			end
		end

feature {NONE} -- Internal attributes

	codec: EL_ZCODEC

feature {NONE} -- Constants

	One_character: STRING_32
		once
			create Result.make_filled ('-', 1)
		end

note
	descendants: "[
			EL_OUTPUT_MEDIUM*
				${EL_PLAIN_TEXT_FILE}
					${EL_CACHED_HTTP_FILE}
					${EL_NOTIFYING_PLAIN_TEXT_FILE}
						${EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE}
				${EL_STREAM_SOCKET*}
					${EL_NETWORK_STREAM_SOCKET}
				${EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM}
				${EL_STRING_IO_MEDIUM*}
					${EL_STRING_8_IO_MEDIUM}
					${EL_ZSTRING_IO_MEDIUM}
	]"
end