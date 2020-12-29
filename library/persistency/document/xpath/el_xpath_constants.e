note
	description: "Xpath constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-29 13:56:13 GMT (Tuesday 29th December 2020)"
	revision: "7"

class
	EL_XPATH_CONSTANTS

feature {NONE} -- Node expressions

	Node_any: STRING_32 = "*"

	Node_comment: STRING_32 = "comment()"

	Node_descendant_or_self: STRING_32 = "descendant-or-self::node()"

	Node_text: STRING_32 = "text()"

	Node_processing_instruction: STRING_32 = "processing-instruction('"

	Node_processing_instruction_end: STRING_32 = "')"

feature {NONE} -- Node type enumeration

	Node_type_element: INTEGER = 1

	Node_type_text: INTEGER = 2

	Node_type_comment: INTEGER = 3

	Node_type_processing_instruction: INTEGER = 4

feature {NONE} -- Step ID enumeration

	Child_element_step_id: INTEGER_16 = 1
		--	// is short for /descendant-or-self::node()/

	Comment_node_step_id: INTEGER = 3

	Descendant_or_self_node_step_id: INTEGER_16 = 2

	Text_node_step_id: INTEGER = 4

  	Num_step_id_constants: INTEGER
  		once
  			Result := Text_node_step_id
  		end

end