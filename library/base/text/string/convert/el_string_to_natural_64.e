note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source NATURAL_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:40:51 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_NATURAL_64

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [NATURAL_64]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `NATURAL_64'
		do
			Result := str.is_natural_64
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): NATURAL_64
		do
			Result := str.to_natural_64
		end

end