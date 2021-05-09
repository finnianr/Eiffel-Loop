note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source NATURAL_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:40:55 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_NATURAL_8

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [NATURAL_8]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `NATURAL_8'
		do
			Result := str.is_natural_8
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): NATURAL_8
		do
			Result := str.to_natural_8
		end

end