note
	description: "Eiffel object builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-14 12:44:06 GMT (Wednesday 14th December 2022)"
	revision: "8"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

feature {NONE} -- Implementation

	extra_field_types: TUPLE [
		EL_REFLECTED_EIF_OBJ_BUILDER_CONTEXT,
		EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT
	]
		do
			create Result
		end

	Eiffel_object_builder_types: EL_TUPLE_TYPE_LIST [EL_REFLECTED_REFERENCE [ANY]]
		once
			create Result.make_from_tuple (extra_field_types)
		end

end