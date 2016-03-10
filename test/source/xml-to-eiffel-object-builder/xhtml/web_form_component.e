note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-27 18:34:43 GMT (Thursday 27th June 2013)"
	revision: "2"

deferred class
	WEB_FORM_COMPONENT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make as make_builder
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable
		end

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make
			--
		do
			make_builder
			make_serializeable
		end

end
