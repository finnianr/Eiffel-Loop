note
	description: "Routine call request parser root builder context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EROS_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT

inherit
	EL_SMART_EIF_OBJ_ROOT_BUILDER_CONTEXT
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
			--
		do
			Precursor (a_root_node_xpath, a_target)
			if attached {like parser} a_target as a_parser then
				parser := a_parser
			else
				create parser.make
			end
			building_actions.extend (agent execute_call, Xpath_processing_instruction_call)
		end

feature {NONE} -- Implementation

	execute_call
		do
			parser.try_parse (node.to_string_8)
		end

feature {NONE} -- Internal attributes

	parser: EROS_CALL_REQUEST_PARSER

feature {NONE} -- Constants

	Xpath_processing_instruction_call: STRING_32
		once
			Result := Pi_template #$ ["call"]
		end

end