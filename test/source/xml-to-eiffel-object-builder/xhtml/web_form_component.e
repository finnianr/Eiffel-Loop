note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	WEB_FORM_COMPONENT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			make_default
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			make_default
		end

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML}
		end

	make
			--
		do
			make_default
			make_empty
		end

end
