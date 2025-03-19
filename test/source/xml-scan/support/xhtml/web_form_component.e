note
	description: "Web form component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:19 GMT (Tuesday 18th March 2025)"
	revision: "9"

deferred class
	WEB_FORM_COMPONENT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

	EVC_SERIALIZEABLE
		redefine
			make_default
		end

	OUTPUT_ROUTINES

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVC_SERIALIZEABLE}
		end

end