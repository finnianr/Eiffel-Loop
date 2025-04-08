note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${REAL_32} or  ${REAL_64}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-07 18:16:17 GMT (Monday 7th April 2025)"
	revision: "9"

deferred class
	EL_READABLE_STRING_GENERAL_TO_REAL [N -> NUMERIC]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [N]
		redefine
			is_convertible, is_substring_convertible, new_type_description
		end

	NUMERIC_INFORMATION
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `N'
		do
			if attached Convertor as l_convertor then
				super_readable_general (str).parse (numeric_type, l_convertor)
				Result := is_real (l_convertor)
			end
		end

	is_substring_convertible (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `str' is convertible to type `N'
		do
			if attached Convertor as l_convertor then
				super_readable_general (str).parse_substring (numeric_type, start_index, end_index, l_convertor)
				Result := is_real (l_convertor)
			end
		end

feature {NONE} -- Implementation

	converted (str: READABLE_STRING_GENERAL): STRING_TO_REAL_CONVERTOR
		do
			Result := Convertor
			super_readable_general (str).parse (Type_no_limitation, Result)
		end

	converted_substring (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): STRING_TO_REAL_CONVERTOR
		do
			Result := Convertor
			super_readable_general (str).parse_substring (Type_no_limitation, start_index, end_index, Result)
		end

	is_real (a_convertor: like Convertor): BOOLEAN
		deferred
		end

	new_type_description: STRING
		-- terse English language description of type
		do
			Result := Precursor + once " number"
		end

	numeric_type: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Convertor: STRING_TO_REAL_CONVERTOR
		once
			Result := EL_string_8.Ctor_convertor
		end
end