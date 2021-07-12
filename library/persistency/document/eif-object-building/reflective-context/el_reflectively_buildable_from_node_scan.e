note
	description: "Reflective buildable from node scan"
	notes: "[
		Override `new_instance_functions' to add creation functions for any attributes conforming to
		class [$source EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT]. For example:
		
			new_instance_functions: ARRAY [FUNCTION [ANY]]
				do
					Result := << agent: FTP_BACKUP do create Result.make end >>
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 7:51:06 GMT (Monday 12th July 2021)"
	revision: "7"

deferred class
	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN

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