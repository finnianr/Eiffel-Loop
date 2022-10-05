note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source NATURAL_64]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 9:26:12 GMT (Wednesday 5th October 2022)"
	revision: "2"

class
	EL_STRING_TO_NATURAL_64

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [NATURAL_64]
		redefine
			is_convertible
		end

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