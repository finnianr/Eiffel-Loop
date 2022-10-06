note
	description: "[
		Sets an operand conforming to [$source EL_MAKEABLE_FROM_STRING [STRING_GENERAL]] in `make' routine argument tuple
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-06 12:26:19 GMT (Thursday 6th October 2022)"
	revision: "6"

class
	EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER

inherit
	EL_MAKE_OPERAND_SETTER [ZSTRING]
		redefine
			put_reference
		end

create
	make

feature {NONE} -- Implementation

	put_reference (a_string: ZSTRING)
		do
			if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} operands.item (index) as makeable then
				makeable.make_from_general (a_string)
			end
		end

	value (str: ZSTRING): ZSTRING
		do
			Result := str
		end
end