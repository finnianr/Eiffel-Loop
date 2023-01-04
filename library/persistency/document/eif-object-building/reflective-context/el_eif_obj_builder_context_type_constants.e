note
	description: "Eiffel object builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 14:23:04 GMT (Wednesday 4th January 2023)"
	revision: "11"

deferred class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implementation

	Eiffel_object_builder_types: EL_REFLECTED_REFERENCE_LIST
		once
			create Result.make (extra_field_types)
		end

	extra_field_types: TUPLE [EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]]
		do
			create Result
		end

feature {NONE} -- Node types

	Attribute_node: INTEGER = 1

	Element_node: INTEGER = 2

	Node_types: ARRAY [INTEGER]
		once
			Result := << Attribute_node, Element_node, Text_element_node >>
		end

	Text_element_node: INTEGER = 3

feature {NONE} -- Xpath components

	Attribute_path: STRING = "/@"

	Item_path: STRING = "/item"

	Text_path: STRING = "/text()"
end