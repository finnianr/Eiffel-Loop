note
	description: "Summary description for {EL_ID3_TAG_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-10 9:26:20 GMT (Saturday 10th January 2015)"
	revision: "4"

class
	EL_ID3_ENCODINGS

feature -- Encoding types

	Encoding_unknown: INTEGER = -1

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

feature -- Code lists

	Valid_ID3_versions: ARRAY [REAL]
			--
		once
			Result := << 2.2, 2.3, 2.4 >>
		end

	Valid_encodings: ARRAY [INTEGER]
			--
		once
			Result := << Encoding_ISO_8859_1, Encoding_UTF_16, Encoding_UTF_16_BE, Encoding_UTF_8 >>
		end

	Encoding_names: HASH_TABLE [STRING, INTEGER]
			--
		once
			create Result.make (4)
			Result [Encoding_ISO_8859_1] := "ISO-8859-1"
			Result [Encoding_UTF_8] := "UTF-8"
			Result [Encoding_UTF_16] := "UTF-16"
			Result [Encoding_UTF_16_BE] := "UTF-16-BE"
			Result [Encoding_unknown] := "Unknown"
			Result.compare_objects
		end

end
