note
	description: "Summary description for {EL_ROUTINE_CALL_REQUEST_XML_TO_EIFFEL_BUILDER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-24 12:47:11 GMT (Thursday 24th December 2015)"
	revision: "4"

class
	EL_ROUTINE_CALL_REQUEST_XML_TO_EIFFEL_BUILDER

inherit
	EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER
		rename
			reset as parse_call_request,
			target as call_argument
		redefine
			make, root_builder_context, parse_call_request
		end

	EL_ROUTINE_CALL_REQUEST_PARSER
		export
			{NONE} all
			{ANY} routine_name, argument_list, class_name, call_request_source_text
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER}
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
