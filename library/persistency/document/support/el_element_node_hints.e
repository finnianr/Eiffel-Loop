note
	description: "[
		Hints for reflective classes as to which fields should be explicitly mapped to XML element text
		with the default being a map to an element attribute.
	]"
	notes: "[
		Map all fields to element attributes
			
			inherit
				EL_ELEMENT_NODE_HINTS
					rename
						element_node_fields as Empty_set
					end

		Map all fields XML element text

			inherit
				EL_ELEMENT_NODE_HINTS
					rename
						element_node_fields as All_fields
					end

		Map selected fields to XML element text
		
			Element_node_fields: STRING = "<f1>, <f2>, .."

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-18 12:55:02 GMT (Tuesday 18th July 2023)"
	revision: "3"

deferred class
	EL_ELEMENT_NODE_HINTS

inherit
	EL_NODE_HINTS

feature {EL_REFLECTION_HANDLER} -- Access

	element_node_field_set: EL_FIELD_INDICES_SET
		do
			Result := Element_node_field_set_table_by_type.item (Current)
		end

feature {EL_ELEMENT_NODE_HINTS} -- Factory

	new_element_node_field_set: EL_FIELD_INDICES_SET
		do
			if element_node_fields = All_fields then
				create Result.make_for_any (field_table)

			elseif element_node_fields.is_empty then
				Result := Empty_field_set
			else
				create Result.make_from_reflective (current_reflective, element_node_fields)
			end
		end

feature {NONE} -- Deferred

	element_node_fields: STRING
		-- list of fields that will be treated as XML elements
		-- (default is element attributes)
		deferred
		ensure
			renamed_to_once_fields: Result.is_empty implies Result = Empty_set or Result = All_fields
			valid_field_names: valid_field_names (Result)
		end

feature {NONE} -- Constants

	All_fields: STRING
		-- rename `element_node_fields' as this to treat all fields as XML elements rather than
		-- attributes
		once ("PROCESS")
			create Result.make_empty
		end

	Element_node_field_set_table_by_type: EL_FUNCTION_RESULT_TABLE [EL_ELEMENT_NODE_HINTS, EL_FIELD_INDICES_SET]
		-- table of fields importable from XML
		once
			create Result.make (17, agent {EL_ELEMENT_NODE_HINTS}.new_element_node_field_set)
		end

end