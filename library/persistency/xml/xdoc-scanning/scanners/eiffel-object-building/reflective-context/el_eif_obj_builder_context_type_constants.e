note
	description: "Eif obj builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 8:38:35 GMT (Tuesday 11th June 2019)"
	revision: "3"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

feature {NONE} -- Constants

	Eif_obj_builder_context_collection_type: INTEGER
		once ("PROCESS")
			Result := ({COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]}).type_id
		end

	Eif_obj_builder_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]
		once
			create Result.make (<<
				[Eif_obj_builder_context_type, {EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT}],
				[Eif_obj_builder_context_collection_type, {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT}]
			>>)
		end

	Eif_obj_builder_context_type: INTEGER
		once ("PROCESS")
			Result := ({EL_EIF_OBJ_BUILDER_CONTEXT}).type_id
		end

end
