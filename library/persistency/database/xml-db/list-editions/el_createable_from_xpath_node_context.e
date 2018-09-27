note
	description: "Createable from xpath node context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_CREATEABLE_FROM_XPATH_NODE_CONTEXT

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML

feature -- Initialization

	make_from_xpath_context (root_context: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		deferred
		end

	make
			--
		do
			make_default
		end
end
