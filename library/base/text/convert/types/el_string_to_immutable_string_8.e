note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source IMMUTABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 16:05:34 GMT (Wednesday 15th March 2023)"
	revision: "6"

class
	EL_STRING_TO_IMMUTABLE_STRING_8

inherit
	EL_TO_STRING_GENERAL_TYPE [IMMUTABLE_STRING_8]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `STRING_8'
		do
			Result := str.is_valid_as_string_8
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		do
			Result := str.to_string_8
		end

end