note
	description: "Summary description for {EL_ROUTINE_CALL_REQUEST_XML_TO_EIFFEL_BUILDER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 12:58:35 GMT (Sunday 21st May 2017)"
	revision: "2"

class
	EL_ROUTINE_CALL_REQUEST_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_SMART_BUILDABLE_FROM_NODE_SCAN
		rename
			reset as parse_call_request,
			target as call_argument
		redefine
			make, root_builder_context, parse_call_request
		end

	EL_ROUTINE_CALL_REQUEST_PARSER
		rename
			make as make_request_parser
		export
			{NONE} all
			{ANY} routine_name, argument_list, class_name, call_request_source_text
		end

create
	make

feature {NONE} -- Initialization

	make (a_parser_type: like parser_type)
		do
			Precursor (a_parser_type)
			make_request_parser
		end

feature -- Status report

	has_error: BOOLEAN

feature {NONE} -- Implementation

	parse_call_request
			--
		do
			has_error := False
			set_source_text (root_builder_context.call_request_string)
			if call_request_source_text.is_empty then
				has_error := True
			else
				parse
			end
			Precursor
		end

	root_builder_context: EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT

end
