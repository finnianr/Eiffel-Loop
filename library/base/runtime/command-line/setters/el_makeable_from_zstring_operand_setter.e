note
	description: "[
		Sets an operand conforming to [$source EL_MAKEABLE_FROM_STRING_GENERAL] in `make' routine argument tuple
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 13:46:55 GMT (Wednesday 29th January 2020)"
	revision: "3"

class
	EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER

inherit
	EL_ZSTRING_OPERAND_SETTER
		redefine
			put_reference
		end

create
	make

feature {NONE} -- Implementation

	put_reference (a_string: ZSTRING; i: INTEGER)
		do
			if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} make_routine.operands.item (i) as makeable then
				makeable.make_from_general (a_string)
			end
		end

end
