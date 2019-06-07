note
	description: "Eif obj builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-07 7:01:32 GMT (Friday 7th June 2019)"
	revision: "1"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

feature {NONE} -- Constants

	COLLECTION_EIF_OBJ_BUILDER_CONTEXT: INTEGER
		once ("PROCESS")
			Result := ({COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]}).type_id
		end

	Builder_context_types: ARRAY [INTEGER]
		once
			Result := << EIF_OBJ_BUILDER_CONTEXT, COLLECTION_EIF_OBJ_BUILDER_CONTEXT >>
		end

	EIF_OBJ_BUILDER_CONTEXT: INTEGER
		once ("PROCESS")
			Result := ({EL_EIF_OBJ_BUILDER_CONTEXT}).type_id
		end

end
