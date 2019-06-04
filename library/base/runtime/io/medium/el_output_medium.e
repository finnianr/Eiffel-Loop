note
	description: "Encoded text medium"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-02 9:20:36 GMT (Sunday 2nd June 2019)"
	revision: "10"

deferred class
	EL_OUTPUT_MEDIUM

inherit
	EL_ENCODEABLE_AS_TEXT
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
		end

	EL_ZCODEC_FACTORY

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create byte_order_mark
			set_codec
			encoding_change_actions.extend (agent set_codec)
		end

feature -- Access

	position: INTEGER
		deferred
		end

feature -- Output

	put_character_32 (c: CHARACTER_32)
		do
			codec.write_encoded_character (c, Current)
		end

	put_character_8 (c: CHARACTER)
		do
			if is_latin_encoding (1) then
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

	put_indented_lines (indent: STRING; lines: LINEAR [READABLE_STRING_GENERAL])
		require
			valid_indent: across indent as c all c.item = '%T' or else c.item = ' ' end
		do
			if position = 0 then
				put_bom
			end
			from lines.start until lines.after loop
				if lines.index > 1 then
					put_new_line
				end
				put_raw_string_8 (indent); put_string_general (lines.item)
				lines.forth
			end
		end

	put_lines (a_lines: FINITE [READABLE_STRING_GENERAL])
		local
			lines: LINEAR [READABLE_STRING_GENERAL]
		do
			if position = 0 then
				put_bom
			end
			lines := a_lines.linear_representation
			from lines.start until lines.after loop
				if lines.index > 1 then
					put_new_line
				end
				put_string_general (lines.item)
				lines.forth
			end
		end

	put_new_line
		deferred
		end

	put_string (str: ZSTRING)
		require else
			valid_encoding: str.has_mixed_encoding implies is_utf_encoding (8)
		do
			if str.encoded_with (codec) then
				str.write_latin (Current)
			else
				codec.write_encoded (str, Current) -- Call back to `put_raw_character_8'
			end
		end

	put_string_32 (str: STRING_32)
		require else
			valid_encoding: not str.is_valid_as_string_8 implies is_utf_encoding (8)
		do
			codec.write_encoded (str, Current)
		end

	put_string_8, put_latin_1 (str: STRING)
		do
			if is_latin_encoding (1) then
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
			Result := byte_order_mark.is_enabled and then is_utf_encoding (8)
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
			codec := new_codec (Current)
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
