note
	description: "Summary description for {EL_VTD_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-01-03 21:04:32 GMT (Thursday 3rd January 2013)"
	revision: "2"

class
	EL_VTD_CONSTANTS

feature {NONE} -- Token types

	Token_PI_name: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_PI_NAME"
		end

	Token_PI_value: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_PI_VAL"
		end

	Token_attribute_name: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_NAME"
		end

	Token_starting_tag: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_STARTING_TAG"
		end

	Token_ending_tag: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ENDING_TAG"
		end

	Token_attr_ns: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_NS"
		end

	Token_attr_val: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_VAL"
		end

	Token_character_data: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_CHARACTER_DATA"
		end

	Token_comment: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_COMMENT"
		end

	Token_dec_attr_name: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DEC_ATTR_NAME"
		end

	Token_dec_attr_val: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DEC_ATTR_VAL"
		end

	Token_cdata_val: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_CDATA_VAL"
		end

	Token_dtd_val: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DTD_VAL"
		end

	Token_document: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DOCUMENT"
		end

feature {NONE} -- Exception types

	Exception_type_out_of_mem: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return out_of_mem"
		end

	Exception_type_invalid_argument: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return invalid_argument"
		end

	Exception_type_array_out_of_bound: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return array_out_of_bound"
		end

	Exception_type_parse_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return parse_exception"
		end

	Exception_type_nav_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return nav_exception"
		end

	Exception_type_pilot_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return pilot_exception"
		end

	Exception_type_number_format_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return number_format_exception"
		end

	Exception_type_xpath_parse_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return xpath_parse_exception"
		end

	Exception_type_xpath_eval_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return xpath_eval_exception"
		end

	Exception_type_modify_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return modify_exception"
		end

	Exception_type_index_write_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return index_write_exception"
		end

	Exception_type_index_read_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return index_read_exception"
		end

	Exception_type_io_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return io_exception"
		end

	Exception_type_transcode_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return transcode_exception"
		end

	Exception_type_other_exception: INTEGER
            --
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return other_exception"
		end

	Exception_type_descriptions: ARRAY [STRING]
			--
		once
			create Result.make (1, 20)
			Result [Exception_type_out_of_mem + 1] := "out of memory"
			Result [Exception_type_invalid_argument + 1] := "invalid argument"
			Result [Exception_type_array_out_of_bound + 1] := "array index out of bound"
			Result [Exception_type_parse_exception + 1] := "parse exception"
			Result [Exception_type_nav_exception + 1] := "navigation exception"
			Result [Exception_type_pilot_exception + 1] := "pilot exception"
			Result [Exception_type_number_format_exception + 1] := "number format exception"
			Result [Exception_type_xpath_parse_exception + 1] := "xpath parse exception"
			Result [Exception_type_xpath_eval_exception + 1] := "xpath eval exception"
			Result [Exception_type_modify_exception + 1] := "modify exception"
			Result [Exception_type_index_write_exception + 1] := "index write exception"
			Result [Exception_type_index_read_exception + 1] := "index read exception"
			Result [Exception_type_io_exception + 1] := "io exception"
			Result [Exception_type_transcode_exception + 1] := "transcode exception"
			Result [Exception_type_other_exception + 1] := "other exception"
 		end

end
