note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source IMMUTABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-10 15:19:18 GMT (Saturday 10th December 2022)"
	revision: "5"

class
	EL_STRING_TO_IMMUTABLE_STRING_8

inherit
	EL_TO_STRING_GENERAL_TYPE [IMMUTABLE_STRING_8]

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		do
			Result := str.to_string_8
		end

end