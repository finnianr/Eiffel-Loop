note
	description: "Convert [$source READABLE_STRING_GENERAL] to type [$source CHARACTER_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-09 8:40:14 GMT (Sunday 9th May 2021)"
	revision: "1"

class
	EL_STRING_TO_CHARACTER_8

inherit
	EL_READABLE_STRING_GENERAL_TO_TYPE [CHARACTER_8]

feature -- Contract Support

	is_convertible (str: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `str' is convertible to type `CHARACTER_8'
		do
			Result := str.count = 1 and then str.code (1) <= 0xFF
		end

feature -- Conversion

	as_type (str: READABLE_STRING_GENERAL): CHARACTER_8
		do
			if is_convertible (str) then
				Result := str.item (1).to_character_8
			end
		end

end