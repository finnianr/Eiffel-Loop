note
	description: "Reflectively buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-11 8:40:51 GMT (Tuesday 11th April 2023)"
	revision: "11"

deferred class
	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		undefine
			is_equal, make_default, new_building_actions
		redefine
			make_default
		end

	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default, Transient_fields
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_BUILDABLE_FROM_NODE_SCAN}
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			PI_building_actions := PI_building_actions_by_type.item (Current)
		end

feature {NONE} -- Implementation

	root_node_name: STRING
			--
		do
			Result := default_root_node_name
			if attached xml_naming as l_naming then
				Result := l_naming.exported (Result)
			end
		end

feature {NONE} -- Constants

	Transient_fields: STRING
		-- comma-separated list of fields that will be treated as if they are transient attributes and
		-- excluded from `field_table'
		once
			Result := Precursor + ", actual_node_source"
		end

end