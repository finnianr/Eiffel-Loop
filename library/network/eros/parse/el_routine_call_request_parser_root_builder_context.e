note
	description: "Routine call request parser root builder context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 16:10:35 GMT (Thursday 9th January 2020)"
	revision: "6"

class
	EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT

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

	parser: EL_ROUTINE_CALL_REQUEST_PARSER

feature {NONE} -- Constants

	Xpath_processing_instruction_call: STRING_32
		once
			Result := Pi_template #$ ["call"]
		end

end
