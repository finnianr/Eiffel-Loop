note
	description: "Underbit id3 tag constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "8"

class
	UNDERBIT_ID3_CONSTANTS

feature {NONE} -- Constants

	File_mode_read_and_write: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FILE_MODE_READWRITE"
		end

	File_mode_read_only: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FILE_MODE_READONLY"
		end

	Tag_version: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_TAG_VERSION"
		end

	Tag_option_ID3v1: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_TAG_OPTION_ID3V1"
		end

feature -- Frame field types

	Field_type_binary_data: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_BINARYDATA"
		end

	Field_type_date: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_DATE"
		end

	Field_type_frame_id: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_FRAMEID"
		end

	Field_type_full_latin1: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LATIN1FULL"
		end

	Field_type_full_string: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_STRINGFULL"
		end

	Field_type_int16: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT16"
		end

	Field_type_int24: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT24"
		end

	Field_type_int32: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT32"
		end

	Field_type_int32_plus: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT32PLUS"
		end

	Field_type_int8: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_INT8"
		end

	Field_type_language: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LANGUAGE"
		end

	Field_type_latin1: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LATIN1"
		end

	Field_type_list_latin1: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_LATIN1LIST"
		end

	Field_type_list_string: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_STRINGLIST"
		end

	Field_type_string: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_STRING"
		end

	Field_type_text_encoding: INTEGER
				--
		external
			"C inline use %"id3tag.h%""
		alias
			"return ID3_FIELD_TYPE_TEXTENCODING"
		end

end