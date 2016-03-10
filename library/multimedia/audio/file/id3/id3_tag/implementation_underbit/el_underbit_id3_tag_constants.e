note
	description: "Summary description for {EL_UNDERBIT_ID3_TAG_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-16 12:26:27 GMT (Friday 16th January 2015)"
	revision: "4"

class
	EL_UNDERBIT_ID3_TAG_CONSTANTS

inherit
	EL_ID3_ENCODINGS

feature -- Constants

	File_mode_read_only: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FILE_MODE_READONLY"
		end

	File_mode_read_and_write: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FILE_MODE_READWRITE"
		end

	Tag_version: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_TAG_VERSION"
		end

feature -- Frame field types

	Field_type_language: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LANGUAGE"
		end

	Field_type_frame_id: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_FRAMEID"
		end

	Field_type_string: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_STRING"
		end

	Field_type_full_string: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_STRINGFULL"
		end

	Field_type_list_string: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_STRINGLIST"
		end

	Field_type_binary_data: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_BINARYDATA"
		end

	Field_type_latin1: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LATIN1"
		end

	Field_type_full_latin1: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LATIN1FULL"
		end

	Field_type_list_latin1: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LATIN1LIST"
		end

	Field_type_text_encoding: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_TEXTENCODING"
		end

	Field_type_int8: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT8"
		end

	Field_type_int16: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT16"
		end

	Field_type_int32: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT32"
		end

feature -- Tag options

	Tag_option_ID3v1: INTEGER
            --
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_TAG_OPTION_ID3V1"
		end

feature {NONE} -- Constants

	Integer_field_types: ARRAY [INTEGER]
			--
		once
			Result := << Field_type_int8, Field_type_int16, Field_type_int32 >>
		end

	String_field_types: ARRAY [INTEGER]
			--
		once
			Result := <<
				Field_type_list_string, Field_type_string, Field_type_full_string, Field_type_frame_id,
				Field_type_latin1, Field_type_full_latin1
			>>
		end

end
