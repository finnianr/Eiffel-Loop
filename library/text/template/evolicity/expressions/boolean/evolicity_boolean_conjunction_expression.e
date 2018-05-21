note
	description: "Evolicity boolean conjunction expression"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION

inherit
	EVOLICITY_BOOLEAN_EXPRESSION

feature {NONE} -- Initialization

	make (right_hand_expression: EVOLICITY_BOOLEAN_EXPRESSION)
			--
		do
			right := right_hand_expression
		end

feature -- Element change

	set_left_hand_expression (left_hand_expression: EVOLICITY_BOOLEAN_EXPRESSION)
			--
		do
			left := left_hand_expression
		end

feature {NONE} -- Implementation

	left: EVOLICITY_BOOLEAN_EXPRESSION

	right: EVOLICITY_BOOLEAN_EXPRESSION

end