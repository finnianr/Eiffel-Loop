note
	description: "Summary description for {EL_TEXT_INDENTABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_OUTPUT_MEDIUM

inherit
	EL_ENCODEABLE_AS_TEXT
		redefine
			set_encoding
		end

	EL_SHARED_CODEC_FACTORY

	STRING_HANDLER

	EL_MODULE_UTF

	EL_SHARED_ONCE_STRINGS

feature -- Access

	position: INTEGER
		deferred
		end

feature -- Output

	put_astring (str: ASTRING)
		require
			valid_encoding: str.has_foreign_characters implies encoding_type = Encoding_utf and encoding = 8
		do
			if encoding_type = Encoding_utf then
				put_string_8 (str.to_utf8)
			else
				if str.encoded_with (codec) and then not str.has_foreign_characters then
					put_string_8 (str.to_string_8)
				else
					put_string_32 (str.to_unicode)
				end
			end
		end

	put_indented_lines (indent: STRING; lines: LINEAR [READABLE_STRING_GENERAL])
		do
			from lines.start until lines.after loop
				put_string (indent); put_string (lines.item)
				put_new_line
				lines.forth
			end
		end

	put_character (c: CHARACTER)
		deferred
		end

	put_new_line
		deferred
		end

	put_string (str: READABLE_STRING_GENERAL)
		do
			if attached {ASTRING} str as astring then
				put_astring (astring)
			elseif attached {STRING} str as str_8 then
				-- Assume STRING types are either latin-1 or utf-8
				if encoding_type = Encoding_iso_8859 and encoding = 1 then
					put_string_8 (str_8)
				elseif encoding_type = Encoding_utf and encoding = 8 then
					put_string_8 (str_8)
				else
					-- Some other latin encoding
					put_string_32 (str_8)
				end
			elseif attached {STRING_32} str as str_32 then
				put_string_32 (str_32)
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
				create {EL_ISO_8859_1_CODEC} codec.make
			end
		end

	set_latin_1_encoding
		do
			set_encoding (Encoding_iso_8859, 1)
		end

feature -- Status query

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

	open_write
		deferred
		end

	open_read
		deferred
		end

feature {NONE} -- Implementation

	codec: EL_CODEC

feature -- Output

	put_bom
			-- put utf-8 byte order mark
		do
			put_string_8 (UTF.Utf_8_bom_to_string_8)
		end

	put_lines (lines: CHAIN [READABLE_STRING_GENERAL])
		do
			if position = 0 and encoding_type = Encoding_utf and encoding = 8 then
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

	put_string_32 (str_32: STRING_32)
		local
			str_8: STRING
		do
			create str_8.make (str_32.count)
			str_8.set_count (str_32.count)
			codec.encode (str_32, str_8.area, 0, empty_once_string)
			put_string_8 (str_8)
		end

	put_string_8 (str: STRING)
		deferred
		end

end
