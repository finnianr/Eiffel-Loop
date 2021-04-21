note
	description: "Token codes from `<vtd_enumerations.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-21 11:02:52 GMT (Wednesday 21st April 2021)"
	revision: "1"

class
	EL_VTD_TOKEN_ENUM

feature -- Access

	PI_name: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_PI_NAME"
		end

	PI_value: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_PI_VAL"
		end

	attribute_name: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_NAME"
		end

	starting_tag: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_STARTING_TAG"
		end

	ending_tag: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ENDING_TAG"
		end

	attr_ns: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_NS"
		end

	attr_val: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_VAL"
		end

	character_data: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_CHARACTER_DATA"
		end

	comment: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_COMMENT"
		end

	dec_attr_name: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DEC_ATTR_NAME"
		end

	dec_attr_val: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DEC_ATTR_VAL"
		end

	cdata_val: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_CDATA_VAL"
		end

	dtd_val: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DTD_VAL"
		end

	document: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DOCUMENT"
		end

end