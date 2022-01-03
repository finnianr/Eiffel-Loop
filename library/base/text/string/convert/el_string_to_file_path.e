note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source FILE_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	EL_STRING_TO_FILE_PATH

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [FILE_PATH]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `FILE_PATH'
		do
			Result := True
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): FILE_PATH
		do
			create Result.make (str)
		end

end