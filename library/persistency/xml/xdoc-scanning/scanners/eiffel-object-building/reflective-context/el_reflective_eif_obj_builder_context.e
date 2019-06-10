note
	description: "Reflective Eiffel object builder (from XML) context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 13:57:16 GMT (Monday 10th June 2019)"
	revision: "8"

deferred class
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
		undefine
			is_equal
		redefine
			make_default
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_field_convertable_from_xml,
			export_name as xml_names,
			import_name as import_default
		export
			{NONE} all
		redefine
			Except_fields, make_default, new_meta_data
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

feature {NONE} -- Implementation

	new_meta_data: EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA
		do
			create Result.make (Current)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := building_actions_for_type (({ANY}), Attribute_node)
		end

	element_node_type: INTEGER
		-- type of XML node mapped to attribute value
		-- Possible values `Text_element_node' or `Attribute_node'
		deferred
		ensure
			valid_node_type: Node_types.has (Result)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", next_context, xpath"
		end

end
