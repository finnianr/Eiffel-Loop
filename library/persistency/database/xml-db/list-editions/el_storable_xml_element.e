note
	description: "Storable xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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