note
	description: "Convert [$source READABLE_STRING_GENERAL] to type conforming to [$source NUMERIC]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 16:42:20 GMT (Wednesday 15th March 2023)"
	revision: "2"

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
		local
			s: EL_STRING_CURSOR_ROUTINES
		do
			if attached Convertor as l_convertor then
				s.shared (str).parse (l_convertor, numeric_type)
				Result := l_convertor.is_integral_integer
			end
		end

	is_integer: BOOLEAN
		do
			Result := False
		end

feature {NONE} -- Implementation

	converted (str: READABLE_STRING_GENERAL): STRING_TO_INTEGER_CONVERTOR
		local
			s: EL_STRING_CURSOR_ROUTINES
		do
			Result := Convertor
			s.shared (str).parse (Result, Type_no_limitation)
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
			Result := Accessible_string_8.Ctoi_convertor
		end

end