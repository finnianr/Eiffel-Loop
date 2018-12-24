note
	description: "[
		Sets an operand conforming to [$source EL_MAKEABLE_FROM_STRING_GENERAL] in `make' routine argument tuple
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 11:59:39 GMT (Sunday 23rd December 2018)"
	revision: "1"

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
			if attached {EL_MAKEABLE_FROM_STRING_GENERAL} app.operands.item (i) as makeable then
				makeable.make_from_general (a_string)
			end
		end

end
