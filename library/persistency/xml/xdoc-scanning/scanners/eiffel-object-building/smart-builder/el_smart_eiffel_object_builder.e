note
	description: "Smart eiffel object builder"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 15:25:41 GMT (Monday 6th January 2020)"
	revision: "1"

class
	EL_SMART_EIFFEL_OBJECT_BUILDER

inherit
	EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
--		redefine
--			new_root_context
--		end

create
	make

feature {NONE} -- Implementation

--	new_root_context: EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT
--		do
--			create Result.make (target.root_node_name, target)
--		end

end
