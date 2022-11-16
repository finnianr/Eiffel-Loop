note
	description: "Web form component"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	WEB_FORM_COMPONENT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

	EVOLICITY_SERIALIZEABLE
		redefine
			make_default
		end

	OUTPUT_ROUTINES

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

end