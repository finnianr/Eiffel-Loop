note
	description: "Reflective Eiffel object builder (from XML) context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-26 18:39:59 GMT (Friday 26th October 2018)"
	revision: "1"

deferred class
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		undefine
			is_equal
		redefine
			make_default
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_string_or_expanded_field,
			export_name as xml_element_name,
			import_name as import_default
		redefine
			Except_fields, make_default
		end

	EL_SETTABLE_FROM_XML_NODE
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			Result := building_actions_for_each_type (field_table.type_list.to_array, element_node_type)
		end

	element_node_type: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", xpath"
		end

end
