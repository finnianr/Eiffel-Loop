note
	description: "Xpath node type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-11 15:11:20 GMT (Friday 11th August 2023)"
	revision: "14"

deferred class
	EL_XPATH_NODE_CONSTANTS

inherit
	EL_STRING_8_CONSTANTS

feature {NONE} -- Node expressions

	Node_name: ARRAY [STRING]
		once
			create Result.make_filled (Empty_string_8, Type_any, Type_processing_instruction)
			Result [Type_any] := "*"
			Result [Type_descendant_or_self] := "descendant-or-self::node()"
			Result [Type_comment] := "comment()"
			Result [Type_text] := "text()"
			Result [Type_processing_instruction] := "processing-instruction"
		ensure
			filled: not Result.has (Empty_string_8)
		end

feature {NONE} -- Special node types

	Type_any: INTEGER = 1
		--	* (short for /descendant-or-self::node())

	Type_descendant_or_self: INTEGER = 2
		-- /descendant-or-self::node()

	Type_comment: INTEGER = 3

	Type_text: INTEGER = 4

	Type_processing_instruction: INTEGER = 5

feature {NONE} -- Abstract node types

	Type_element: INTEGER = 6

	Type_attribute: INTEGER = 7

end