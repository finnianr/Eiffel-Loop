note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source DIR_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	EL_STRING_TO_DIR_PATH

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [DIR_PATH]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `DIR_PATH'
		do
			Result := True
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): DIR_PATH
		do
			create Result.make (str)
		end

end