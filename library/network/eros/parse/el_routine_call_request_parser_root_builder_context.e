note
	description: "Summary description for {EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT
		redefine
			make, reset
		end

create
	make

feature {NONE} -- Initialization

	make (a_root_node_xpath: STRING; a_target: like target)
			--
		do
			create call_request_string.make_empty
			Precursor (a_root_node_xpath, a_target)
		end

feature -- Access

	call_request_string: STRING

feature -- Element change

	reset
			-- Reset builder
		do
			Precursor
			call_request_string.clear_all
			building_actions.extend (agent set_call_request_string, Xpath_processing_instruction_call)
		end

feature {NONE} -- Implementation

	set_call_request_string
			--
		do
			call_request_string := node.to_string
		end

	Xpath_processing_instruction_call: STRING = "processing-instruction('call')"

end

