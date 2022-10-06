note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-06 8:08:15 GMT (Thursday 6th October 2022)"
	revision: "3"

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