note
	description: "Summary description for {EL_CREATEABLE_FROM_XPATH_NODE_CONTEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_CREATEABLE_FROM_XPATH_NODE_CONTEXT

inherit

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			make as make_serializeable
		end

feature -- Initialization

	make_from_xpath_context (root_context: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		deferred
		end

	make
			--
		do
			make_serializeable
		end
end
