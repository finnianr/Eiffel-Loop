note
	description: "Underbit string handling C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 7:59:12 GMT (Friday 18th August 2023)"
	revision: "10"

class
	UNDERBIT_ID3_STRING_C_API

inherit
	EL_C_API_ROUTINES
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- Measurement

	c_ucs_4_length (ucs4_ptr: POINTER): INTEGER
		-- id3_length_t id3_ucs4_length(id3_ucs4_t const *);
		require
			argument_attached: is_attached (ucs4_ptr)
		external
			"C (id3_ucs4_t const *): EIF_INTEGER | %"ucs4.h%""
		alias
			"id3_ucs4_length"
		end

	c_utf_16_length (utf_16_ptr: POINTER): INTEGER
		-- id3_length_t id3_utf16_length(id3_utf16_t const *);
		require
			argument_attached: is_attached (utf_16_ptr)
		external
			"C (id3_utf16_t const *): EIF_INTEGER | %"utf16.h%""
		alias
			"id3_utf16_length"
		end

	c_utf_8_length (utf_8_ptr: POINTER): INTEGER
		-- id3_length_t id3_utf8_length(id3_utf8_t const *);
		require
			argument_attached: is_attached (utf_8_ptr)
		external
			"C (id3_utf8_t const *): EIF_INTEGER | %"utf8.h%""
		alias
			"id3_utf8_length"
		end

feature -- Basic operations

	c_id3_utf_16_decode (utf_16_ptr, unicode_ptr: POINTER)
		-- void id3_utf16_decode(id3_utf16_t const *, id3_ucs4_t *);
		require
			arguments_attached: is_attached (utf_16_ptr) and is_attached (unicode_ptr)
		external
			"C (id3_utf16_t const *, id3_ucs4_t *) | %"utf16.h%""
		alias
			"id3_utf16_decode"
		end

	c_id3_utf_8_decode (utf_8_ptr, unicode_ptr: POINTER)
		-- void id3_utf8_decode(id3_utf8_t const *, id3_ucs4_t *);
		require
			arguments_attached: is_attached (utf_8_ptr) and is_attached (unicode_ptr)
		external
			"C (id3_utf8_t const *, id3_ucs4_t *) | %"utf8.h%""
		alias
			"id3_utf8_decode"
		end

feature  {ID3_ENCODING_ENUM} -- Encodings

	Encoding_ISO_8859_1: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TEXTENCODING_ISO_8859_1"
		end

	Encoding_UTF_16: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TEXTENCODING_UTF_16"
		end

	Encoding_UTF_16_BE: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TEXTENCODING_UTF_16BE"
		end

	Encoding_UTF_8: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TEXTENCODING_UTF_8"
		end

end