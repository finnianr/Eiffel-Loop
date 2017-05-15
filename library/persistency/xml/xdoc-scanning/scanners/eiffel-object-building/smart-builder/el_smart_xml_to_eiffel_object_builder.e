note
	description: "[
		Detects the desired target type from XML processing instruction `create {G}' 
		and sets the type of target_object to G where G is a type conforming to `EL_BUILDABLE_FROM_XML'. 
		Built object is made available as `product'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-14 11:59:59 GMT (Sunday 14th May 2017)"
	revision: "2"

class
	EL_SMART_XML_TO_EIFFEL_OBJECT_BUILDER

inherit
	EL_SMART_BUILDABLE_FROM_NODE_SCAN [EL_EXPAT_XML_PARSER]

create
	make

end
