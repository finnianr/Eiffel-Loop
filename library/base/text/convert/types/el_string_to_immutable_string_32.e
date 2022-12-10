note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source IMMUTABLE_STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-10 15:38:53 GMT (Saturday 10th December 2022)"
	revision: "5"

class
	EL_STRING_TO_IMMUTABLE_STRING_32

inherit
	EL_TO_STRING_GENERAL_TYPE [IMMUTABLE_STRING_32]
		redefine
			is_latin_1
		end

feature -- Status query

	is_latin_1: BOOLEAN = False
		-- `True' if type can be always be represented by Latin-1 encoded string

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): IMMUTABLE_STRING_32
		do
			Result := str.to_string_32
		end

end