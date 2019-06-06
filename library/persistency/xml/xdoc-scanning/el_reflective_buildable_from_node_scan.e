note
	description: "Reflective buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 9:57:49 GMT (Thursday 6th June 2019)"
	revision: "2"

deferred class
	EL_REFLECTIVE_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		undefine
			is_equal, make_default, new_building_actions
		end

	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			PI_building_actions := PI_building_actions_by_type.item (Current)
		end

end
