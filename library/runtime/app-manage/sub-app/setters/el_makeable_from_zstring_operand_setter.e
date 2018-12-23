note
	description: "[
		Sets an operand conforming to [$source EL_MAKEABLE_FROM_STRING_GENERAL] in `make' routine argument tuple
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
