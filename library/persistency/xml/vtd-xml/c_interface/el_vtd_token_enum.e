note
	description: "Token codes from `<vtd_enumerations.h>'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-22 11:28:18 GMT (Saturday 22nd January 2022)"
	revision: "2"

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

	attribute_name_space: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_NS"
		end

	attribute_value: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ATTR_VAL"
		end

	character_data_value: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_CDATA_VAL"
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

	declaration_attribute_name: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DEC_ATTR_NAME"
		end

	declaration_attribute_value: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DEC_ATTR_VAL"
		end

	document: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DOCUMENT"
		end

	dtd_value: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_DTD_VAL"
		end

	ending_tag: INTEGER
 		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_ENDING_TAG"
		end

	starting_tag: INTEGER
		external
			"C inline use <vtd_enumerations.h>"
		alias
			"return TOKEN_STARTING_TAG"
		end

end