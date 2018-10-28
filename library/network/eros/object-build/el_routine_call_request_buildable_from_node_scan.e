note
	description: "Routine call request buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

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

	make (a_parse_event_source_type: like parse_event_source_type)
		do
			Precursor (a_parse_event_source_type)
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
