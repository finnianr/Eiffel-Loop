note
	description: "Summary description for {EL_XML_RECORD_STORABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
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
