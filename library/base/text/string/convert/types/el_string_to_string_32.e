note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_STRING_TO_STRING_32

inherit
	EL_TO_STRING_GENERAL_TYPE [STRING_32]

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): STRING_32
		do
			Result := str.to_string_32
		end

end