note
	description: "Storable xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_STORABLE_XML_ELEMENT

inherit
	EVOLICITY_SERIALIZEABLE

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