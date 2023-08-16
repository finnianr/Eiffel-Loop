note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source REAL_32] or  [$source REAL_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 9:16:55 GMT (Monday 31st July 2023)"
	revision: "3"

deferred class
	EL_READABLE_STRING_GENERAL_TO_REAL [N -> NUMERIC]

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

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `N'
		local
			s: EL_STRING_CURSOR_ROUTINES
		do
			if attached Convertor as l_convertor then
				s.shared (str).parse (l_convertor, numeric_type)
				Result := is_real (l_convertor)
			end
		end

feature {NONE} -- Implementation

	converted (str: READABLE_STRING_GENERAL): STRING_TO_REAL_CONVERTOR
		local
			s: EL_STRING_CURSOR_ROUTINES
		do
			Result := Convertor
			s.shared (str).parse (Result, Type_no_limitation)
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