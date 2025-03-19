note
	description: "Storable xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:19 GMT (Tuesday 18th March 2025)"
	revision: "7"

deferred class
	EL_STORABLE_XML_ELEMENT

inherit
	EVC_SERIALIZEABLE

feature -- Element change

	set_from_xpath_node (element_node: EL_XPATH_NODE_CONTEXT)
			--
		deferred
		end

feature -- Access

	element_name: STRING
			--
		deferred
		end

end