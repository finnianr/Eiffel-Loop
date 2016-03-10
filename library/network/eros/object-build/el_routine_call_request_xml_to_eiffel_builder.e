note
	description: "Summary description for {EL_ROUTINE_CALL_REQUEST_XML_TO_EIFFEL_BUILDER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ROUTINE_CALL_REQUEST_XML_TO_EIFFEL_BUILDER

inherit
	EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER
		rename
			reset as parse_call_request,
			target as call_argument
		redefine
			default_create, root_builder_context, parse_call_request
		end

	EL_ROUTINE_CALL_REQUEST_PARSER
		rename
			make as make_call_request_parser
		export
			{NONE} all
			{ANY} routine_name, argument_list, class_name, call_request_source_text
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	default_create
			--
		do
			make_call_request_parser
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
				if full_match_succeeded then
					consume_events
				else
					has_error := True
				end
			end
			Precursor
		end

	root_builder_context: EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT

end
