note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source CHARACTER_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-05 9:28:34 GMT (Wednesday 5th October 2022)"
	revision: "2"

class
	EL_STRING_TO_CHARACTER_8

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [CHARACTER_8]
		redefine
			is_convertible
		end

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `CHARACTER_8'
		do
			Result := str.count = 1 and then str.code (1) <= 0xFF
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): CHARACTER_8
		do
			if str.count >= 1 then
				Result := str [1].to_character_8
			end
		end

end