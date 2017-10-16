note
	description: "Summary description for {EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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