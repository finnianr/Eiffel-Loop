note
	description: "Convert [$source READABLE_STRING_GENERAL] to type conforming to [$source NUMERIC]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-11 8:57:31 GMT (Saturday 11th November 2023)"
	revision: "4"

deferred class
	EL_READABLE_STRING_GENERAL_TO_NUMERIC [N -> NUMERIC]

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [N]
		redefine
			is_convertible, new_type_description
		end

	NUMERIC_INFORMATION
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

feature -- Status query

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `N'
		do
			if attached Convertor as l_convertor then
				shared_cursor (str).parse (l_convertor, numeric_type)
				Result := l_convertor.is_integral_integer
			end
		end

	is_integer: BOOLEAN
		do
			Result := False
		end

feature {NONE} -- Implementation

	converted (str: READABLE_STRING_GENERAL): STRING_TO_INTEGER_CONVERTOR
		do
			Result := Convertor
			shared_cursor (str).parse (Result, Type_no_limitation)
		end

	new_type_description: STRING
		-- terse English language description of type
		do
			if is_integer then
				Result := Precursor
			else
				Result := Precursor + once " number"
			end
		end

	numeric_type: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Convertor: STRING_TO_INTEGER_CONVERTOR
		once
			Result := EL_string_8.Ctoi_convertor
		end

end