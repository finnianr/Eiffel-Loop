note
	description: "Reflectively buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 10:25:55 GMT (Friday 6th January 2023)"
	revision: "10"

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

	EL_MODULE_NAMING

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_BUILDABLE_FROM_NODE_SCAN}
			Precursor {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}
			PI_building_actions := PI_building_actions_by_type.item (Current)
		end

feature {NONE} -- Implementation

	class_prefix_word_count: INTEGER
		-- number of words used as prefix for class name
		do
			inspect generator.index_of ('_', 1)
			 	when 2, 3 then
			 		Result := 1
			 else
			 	Result := 0
			 end
		end

	default_root_node_name: STRING
		-- `generator.as_lower' with `class_prefix_word_count' words pruned from start
		do
			Result := Naming.class_as_snake_lower (Current, class_prefix_word_count, 0)
		end

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