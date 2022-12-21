note
	description: "Eiffel object builder context type constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-21 21:28:56 GMT (Wednesday 21st December 2022)"
	revision: "9"

class
	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

feature {NONE} -- Implementation

	extra_field_types: TUPLE [EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]]
		do
			create Result
		end

	Eiffel_object_builder_types: EL_REFLECTED_REFERENCE_LIST
		once
			create Result.make (extra_field_types)
		end

end