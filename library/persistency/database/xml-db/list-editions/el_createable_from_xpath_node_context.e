note
	description: "Createable from xpath node context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:32 GMT (Tuesday 18th March 2025)"
	revision: "8"

deferred class
	EL_CREATEABLE_FROM_XPATH_NODE_CONTEXT

inherit
	EVC_SERIALIZEABLE_AS_XML

feature -- Initialization

	make_from_xpath_context (root_context: EL_XML_DOC_CONTEXT)
			--
		deferred
		end

	make
			--
		do
			make_default
		end
end