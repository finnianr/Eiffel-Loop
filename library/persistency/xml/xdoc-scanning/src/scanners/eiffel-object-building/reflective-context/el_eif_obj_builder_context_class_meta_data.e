note
	description: "Eif obj builder context class meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-17 7:06:20 GMT (Wednesday 17th July 2019)"
	revision: "5"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA

inherit
	EL_CLASS_META_DATA
		redefine
			Reference_type_tables
		end

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

create
	make

feature {NONE} -- Constants

	Reference_type_tables: ARRAY [EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]]
		once
			Result := <<
				String_type_table,
				Boolean_ref_type_table,
				Makeable_from_string_type_table,
				String_convertable_type_table,
				Eif_obj_builder_type_table,
				String_collection_type_table,
				Numeric_collection_type_table,
				Other_collection_type_table
			>>
		end

end
