note
	description: "Encoded text medium"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 11:58:01 GMT (Thursday 14th May 2020)"
	revision: "19"

deferred class
	EL_OUTPUT_MEDIUM

inherit
	EL_ENCODEABLE_AS_TEXT
		rename
			make as make_encodeable
		redefine
			make_default
		end

	EL_WRITEABLE
		rename
			write_raw_character_8 as put_raw_character_8, -- Allows UTF-8 conversion
			write_raw_string_8 as put_raw_string_8,

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

	EL_SHARED_ZCODEC_FACTORY

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			create byte_order_mark
			Precursor
			set_codec
			add_encoding_change_action (agent set_codec)
		end

feature -- Access

	position: INTEGER
		deferred
		end

feature -- Output

	put_character_32 (c: CHARACTER_32)
		do
			if encoded_as_latin (1) then
				if c.is_character_8 then
					put_raw_character_8 (c.to_character_8)
				else
					put_raw_character_8 ({EL_ZCODE_CONVERSION}.Unencoded_character)
				end
			else
				codec.write_encoded_character (c, Current)
			end
		end

	put_character_8 (c: CHARACTER)
		do
			if encoded_as_latin (1) then
				put_raw_character_8 (c)
			else
				codec.write_encoded_character (c, Current)
			end
		end

	put_pointer (p: POINTER)
		do
			put_raw_string_8 (p.out)
		end

feature -- String output

	put_bom
			-- put utf-8 byte order mark for UTF-8 encoding
		require
			start_of_file: position = 0
		do
			if is_bom_writeable then
				put_raw_string_8 ({UTF_CONVERTER}.Utf_8_bom_to_string_8)
			end
		end

	put_indent (tab_count: INTEGER)
		local
			i: INTEGER
		do
			from i := 1 until i > tab_count loop
				put_raw_character_8 ('%T')
				i := i + 1
			end
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
					put_raw_string_8 (indent)
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

	put_new_line
		deferred
		end

	put_string (str: ZSTRING)
		require else
			valid_encoding: str.has_mixed_encoding implies encoded_as_utf (8)
		do
			if str.encoded_with (codec) then
				str.write_latin (Current)
			else
				codec.write_encoded (str, Current) -- Call back to `put_raw_character_8'
			end
		end

	put_string_general (str: READABLE_STRING_GENERAL)
		require else
			valid_encoding: not str.is_valid_as_string_8 implies encoded_as_utf (8)
		do
			codec.write_encoded (str, Current)
		end

	put_string_32 (str: READABLE_STRING_32)
		require else
			valid_encoding: not str.is_valid_as_string_8 implies encoded_as_utf (8)
		do
			codec.write_encoded (str, Current)
		end

	put_string_8, put_latin_1 (str: READABLE_STRING_8)
		do
			if encoded_as_latin (1) then
				put_raw_string_8 (str)
			else
				codec.write_encoded (str, Current) -- Call back to `put_raw_character_8'
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

	set_codec
			--
		do
			codec := Codec_factory.codec (Current)
		end

feature {NONE} -- Internal attributes

	codec: EL_ZCODEC;

note
	descendants: "[
		**eiffel.ecf**
			EL_OUTPUT_MEDIUM*
				[$source EL_PLAIN_TEXT_FILE]
					[$source SOURCE_FILE]
				[$source EL_STRING_IO_MEDIUM]*
					[$source EL_STRING_8_IO_MEDIUM]
					[$source EL_ZSTRING_IO_MEDIUM]
	]"
end
