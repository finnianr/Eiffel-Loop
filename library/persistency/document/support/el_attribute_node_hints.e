note
	description: "[
		Hints for reflective classes as to which fields should be explicitly mapped to XML attribute text
	]"
	notes: "[
		Map selected fields to XML attribute text
		
			Attribute_node_fields: STRING = "<f1>, <f2>, .."

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-19 17:14:24 GMT (Wednesday 19th July 2023)"
	revision: "3"

deferred class
	EL_ATTRIBUTE_NODE_HINTS

inherit
	EL_NODE_HINTS

feature {EL_REFLECTION_HANDLER} -- Access

	attribute_node_field_set: EL_FIELD_INDICES_SET
		do
			Result := Attribute_node_field_set_table_by_type.item (Current)
		end

feature {EL_ATTRIBUTE_NODE_HINTS} -- Factory

	new_attribute_node_field_set: EL_FIELD_INDICES_SET
		do
			if attribute_node_fields.is_empty then
				Result := Empty_field_set
			else
				create Result.make (current_reflective.field_info_table, attribute_node_fields)
			end
		end

feature {NONE} -- Deferred

	attribute_node_fields: STRING
		-- list of fields that will be treated as XML attributes
		deferred
		ensure
			renamed_to_once_fields: Result.is_empty implies Result = Empty_set
			valid_field_names: valid_field_names (Result)
		end

feature {NONE} -- Constants

	Attribute_node_field_set_table_by_type: EL_FUNCTION_RESULT_TABLE [EL_ATTRIBUTE_NODE_HINTS, EL_FIELD_INDICES_SET]
		-- table of fields importable from XML
		once
			create Result.make (17, agent {EL_ATTRIBUTE_NODE_HINTS}.new_attribute_node_field_set)
		end

end