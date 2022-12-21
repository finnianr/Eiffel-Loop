note
	description: "Eiffel object builder context class meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-19 10:02:34 GMT (Monday 19th December 2022)"
	revision: "13"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			extend_group_ordering, extend_field_types, Reference_group_table
		end

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

create
	make

feature {NONE} -- Implementation

	extend_group_ordering (order_table: like Group_type_order_table)
		local
			order_no: INTEGER
		once
			order_no := order_table [{EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}]  + 2

			order_table [{EL_EIF_OBJ_BUILDER_CONTEXT}] := order_no
			order_table [{COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]}] := order_no
		end

	extend_field_types (a_field_list: like Reference_field_list)
		once
			a_field_list.append_types (extra_field_types)
		end

feature {NONE} -- Constants

	Reference_group_table: EL_FUNCTION_GROUP_TABLE [EL_REFLECTED_REFERENCE [ANY], TYPE [ANY]]
		once
			Result := new_reference_group_table
		end

end