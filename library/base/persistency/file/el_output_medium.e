note
	description: "Encoded text medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 11:46:25 GMT (Sunday 3rd September 2017)"
	revision: "3"

deferred class
	EL_OUTPUT_MEDIUM

inherit
	EL_WRITEABLE
		rename
			write_character_8 as put_raw_character, -- Allows UTF-8 conversion
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
			write_string as put_string_z,
			write_string_8 as put_string_8,
			write_string_32 as put_string_32,
			write_string_general as put_string_general,
			write_boolean as put_boolean,
			write_pointer as put_pointer
		end

	EL_ENCODEABLE_AS_TEXT
		redefine
			make_default
		end

	EL_ZCODEC_FACTORY

	EL_MODULE_UTF

	EL_MODULE_CHARACTER

	EL_MODULE_STRING_32

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			set_codec
			encoding_change_actions.extend (agent set_codec)
		end

feature -- Access

	position: INTEGER
		deferred
		end

feature -- Output

	put_character (c: CHARACTER)
		do
			if encoding_type = Encoding_iso_8859 and encoding = 1 then
				put_raw_character (c)
			elseif encoding_type = Encoding_utf and encoding = 8 then
				Character.write_utf_8 (c, Current)
			else
				put_raw_character (codec.encoded_character (c.natural_32_code))
			end
		end

	put_character_32 (c: CHARACTER_32)
		do
			if encoding_type = Encoding_utf and encoding = 8 then
				Character.write_utf_8 (c, Current)
			else
				put_raw_character (codec.encoded_character (c.natural_32_code))
			end
		end

	put_pointer (p: POINTER)
		do
			put_raw_string_8 (p.out)
		end

	put_raw_character (c: CHARACTER)
		deferred
		end

feature -- String output

	put_bom
			-- put utf-8 byte order mark for UTF-8 encoding
		require
			start_of_file: position = 0
		do
			if is_bom_writeable then
				put_raw_string_8 (UTF.Utf_8_bom_to_string_8)
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
				put_raw_string_8 (indent); put_string (lines.item)
				put_new_line
				lines.forth
			end
		end

	put_lines (lines: LINEAR [READABLE_STRING_GENERAL])
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

	put_new_line
		deferred
		end

	put_raw_string_8 (str: STRING)
		-- put encoded string
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

	put_string_32 (str_32: STRING_32)
		do
			if encoding_type = Encoding_utf and encoding = 8 then
				String_32.write_utf_8 (str_32, Current)
			else
				codec.write_encoded (str_32, Current)
			end
		end

	put_string_8, put_latin_1 (str: STRING)
		do
			-- Assume STRING types are either latin-1 or utf-8
			if encoding_type = Encoding_iso_8859 and encoding = 1 then
				put_raw_string_8 (str)
			elseif encoding_type = Encoding_utf and encoding = 8 then
				String_32.write_utf_8 (str, Current)
			else
				-- Some other latin encoding
				put_string_32 (str)
			end
		end

	put_string_z (str: ZSTRING)
		require else
			valid_encoding: str.has_mixed_encoding implies encoding_type = Encoding_utf and encoding = 8
		do
			if encoding_type = Encoding_utf then
				put_raw_string_8 (str.to_utf_8)
			else
				if str.encoded_with (codec) then
					put_raw_string_8 (str.to_latin_string_8)
				else
					put_string_32 (str.to_unicode)
				end
			end
		end

feature -- Element change

	set_codec
			--
		do
			if encoding_type = Encoding_utf then
				create {EL_ISO_8859_1_ZCODEC} codec.make
			else
				codec := new_codec (Current)
			end
		end

	set_latin_1_encoding
		do
			set_encoding (Encoding_iso_8859, 1)
		end

feature -- Status change

	disable_bom
		do
			is_bom_enabled := False
		end

	enable_bom
		do
			is_bom_enabled := True
		end

feature -- Status query

	is_bom_enabled: BOOLEAN
		-- True if UTF-8 byte-order-mark writing is enabled

	is_bom_writeable: BOOLEAN
		do
			Result := is_bom_enabled and then (encoding_type = Encoding_utf and encoding = 8)
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

	codec: EL_ZCODEC
end
