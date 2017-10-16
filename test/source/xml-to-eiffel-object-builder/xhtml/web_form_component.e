note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

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

end