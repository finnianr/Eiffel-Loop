note
	description: "Summary description for {EL_XPATH_TOKEN_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_XPATH_TOKEN_CONSTANTS

feature {NONE} -- Constants

	Comment_node: STRING_32 = "comment()"

	Child_element: STRING_32 = "*"

	Text_node: STRING_32 = "text()"

	Descendant_or_self_node: STRING_32 = "descendant-or-self::node()"

	Child_element_step_id: INTEGER_16 = 1

--	// is short for /descendant-or-self::node()/

	Descendant_or_self_node_step_id: INTEGER_16 = 2

	Comment_node_step_id: INTEGER = 3

	Text_node_step_id: INTEGER = 4

  	Num_step_id_constants: INTEGER
  		once
  			Result := Text_node_step_id
  		end

end