note
	description: "Smart node scan to eiffel object builder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 16:05:29 GMT (Sunday 20th December 2020)"
	revision: "2"

class
	EL_SMART_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER

inherit
	EL_DOCUMENT_EIFFEL_OBJECT_BUILDER
		redefine
			new_builder_context, target
		end

create
	make

feature {NONE} -- Implementation

	new_builder_context (root_node_name: STRING): EL_EIF_OBJ_ROOT_BUILDER_CONTEXT
			--
		do
			Result := target.new_root_builder_context
		end

feature {NONE} -- Internal attributes

	target: EL_SMART_BUILDABLE_FROM_NODE_SCAN
end