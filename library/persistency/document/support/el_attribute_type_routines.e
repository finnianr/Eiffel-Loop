note
	description: "Type of [$source EL_REFLECTED_FIELD] for purposes of mapping to XML attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-03 19:16:40 GMT (Tuesday 3rd January 2023)"
	revision: "1"

expanded class
	EL_ATTRIBUTE_TYPE_ROUTINES

inherit
	ANY

	EL_REFLECTION_HANDLER

feature -- Access

	attribute_id (field: EL_REFLECTED_FIELD): INTEGER
		do
			if attached {EL_REFLECTED_BOOLEAN} field or else attached {EL_REFLECTED_BOOLEAN_REF} field then
				Result := Type_boolean

			elseif attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field then
				if expanded_field.has_string_representation then
					Result := Type_unquoted
				else
					Result := Type_expanded
				end
			elseif attached {EL_ELEMENT_NODE_HINTS} field.enclosing_object as hints
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

	Types_expanded_to_quoted: INTEGER_INTERVAL
		once
			Result := Type_expanded |..| Type_quoted
		end
end