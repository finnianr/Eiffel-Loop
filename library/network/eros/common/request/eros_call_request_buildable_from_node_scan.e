note
	description: "Routine call request buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 8:21:22 GMT (Monday 21st November 2022)"
	revision: "13"

class
	EROS_CALL_REQUEST_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_SMART_BUILDABLE_FROM_NODE_SCAN
		rename
			item as call_argument,
			has_item as has_call_argument
		redefine
			make_default, new_root_builder_context
		end

	EROS_CALL_REQUEST_PARSER
		rename
			make as make_default
		export
			{NONE} all
			{EROS_CALL_REQUEST_HANDLER} class_name, has_error, call_text
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
			Precursor {EROS_CALL_REQUEST_PARSER}
			Precursor {EL_SMART_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	new_root_builder_context: EROS_CALL_REQUEST_PARSER_ROOT_BUILDER_CONTEXT
			--
		do
			create Result.make (root_node_name, Current)
		end

end