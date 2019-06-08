note
	description: "Eif obj builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-08 8:21:43 GMT (Saturday 8th June 2019)"
	revision: "2"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

feature {NONE} -- Constants

	Eif_obj_builder_context_collection_type: INTEGER
		once ("PROCESS")
			Result := ({COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]}).type_id
		end

	Builder_context_types: ARRAY [INTEGER]
		once
			Result := << Eif_obj_builder_context_type, Eif_obj_builder_context_collection_type >>
		end

	Eif_obj_builder_context_type: INTEGER
		once ("PROCESS")
			Result := ({EL_EIF_OBJ_BUILDER_CONTEXT}).type_id
		end

end
