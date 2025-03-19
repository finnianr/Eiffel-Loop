note
	description: "Evolicity boolean conjunction expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:02:06 GMT (Tuesday 18th March 2025)"
	revision: "6"

deferred class
	EVC_BOOLEAN_CONJUNCTION_EXPRESSION

inherit
	EVC_BOOLEAN_EXPRESSION

feature {NONE} -- Initialization

	make (right_hand_expression: EVC_BOOLEAN_EXPRESSION)
			--
		do
			right := right_hand_expression
		end

feature -- Element change

	set_left_hand_expression (left_hand_expression: EVC_BOOLEAN_EXPRESSION)
			--
		do
			left := left_hand_expression
		end

feature {NONE} -- Implementation

	left: EVC_BOOLEAN_EXPRESSION

	right: EVC_BOOLEAN_EXPRESSION

end