note
	description: "Reflectively buildable from pyxis"
	descendants: "[
			EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS*
				[$source TASK_CONFIG]
					[$source TEST_TASK_CONFIG]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-31 12:48:47 GMT (Saturday 31st August 2019)"
	revision: "2"

deferred class
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			xml_name_space as xmlns
		undefine
			is_equal, new_building_actions
		redefine
			make_default
		end

	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_type as	Attribute_node,
			xml_names as export_default,
			xml_name_space as xmlns
		export
			{NONE} all
		redefine
			make_default
		end

	EL_MODULE_XML

feature {NONE} -- Initialization

	make_default
		do
			register_default_values
			create node_source.make (agent new_node_source)
			Precursor {EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	register_default_values
		-- Implement this as a once routine to register a default value for any attributes
		-- conforming to class `EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT'.
	 	-- For example:
		-- once
		--		Default_value_table.extend_from_array (<< create {like values}.make_default >>)
		--	end
		deferred
		end

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 0)
		end

end
