note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source EL_DIR_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 9:04:55 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_DIR_PATH

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [EL_DIR_PATH]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `EL_DIR_PATH'
		do
			Result := True
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			create Result.make (str)
		end

end