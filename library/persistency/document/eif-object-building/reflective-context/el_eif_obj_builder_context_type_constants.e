note
	description: "Eifel object builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

feature {NONE} -- Constants

	Eif_obj_builder_type_table: EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]
		once
			create Result.make (<<
				{EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT}, {EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT}
			>>)
		end

end