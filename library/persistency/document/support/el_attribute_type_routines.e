note
	description: "Type of ${EL_REFLECTED_FIELD} for purposes of mapping to XML attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-16 15:06:22 GMT (Thursday 16th November 2023)"
	revision: "3"

expanded class
	EL_ATTRIBUTE_TYPE_ROUTINES

inherit
	ANY

	EL_REFLECTION_HANDLER

feature -- Access

	attribute_id (object: EL_REFLECTIVE; field: EL_REFLECTED_FIELD): INTEGER
		require
			valid_field_object: field.valid_type (object)
		do
			if attached {EL_REFLECTED_BOOLEAN} field or else attached {EL_REFLECTED_BOOLEAN_REF} field then
				Result := Type_boolean

			elseif attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field then
				if expanded_field.has_string_representation then
					Result := Type_unquoted
				else
					Result := Type_expanded
				end
			elseif attached {EL_ATTRIBUTE_NODE_HINTS} object as hints
				and then hints.attribute_node_field_set.has (field.index)
			then
				Result := Type_quoted

			elseif attached {EL_ELEMENT_NODE_HINTS} object as hints
				and then not hints.element_node_field_set.has (field.index)
			then
				Result := Type_quoted
			end
		end

feature -- Constants

	Type_boolean: INTEGER = 1

	Type_expanded: INTEGER = 2

	Type_unquoted: INTEGER = 3

	Type_quoted: INTEGER = 4

end