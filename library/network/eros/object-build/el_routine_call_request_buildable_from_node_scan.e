note
	description: "Routine call request buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 12:03:08 GMT (Monday 13th January 2020)"
	revision: "8"

class
	EL_ROUTINE_CALL_REQUEST_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_SMART_BUILDABLE_FROM_NODE_SCAN
		rename
			item as call_argument,
			has_item as has_call_argument
		redefine
			make_default, new_root_builder_context
		end

	EL_ROUTINE_CALL_REQUEST_PARSER
		rename
			make as make_default
		export
			{NONE} all
			{EL_REMOTE_ROUTINE_CALL_REQUEST_HANDLER} class_name, source_text, has_error
		undefine
			call_argument, has_call_argument
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_ROUTINE_CALL_REQUEST_PARSER}
			Precursor {EL_SMART_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	new_root_builder_context: EL_ROUTINE_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT
			--
		do
			create Result.make (root_node_name, Current)
		end

end
