note
	description: "Summary description for {EVOLICITY_BOOLEAN_CONJUNCTION_EXPRESSION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

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
