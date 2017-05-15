note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-14 13:36:35 GMT (Sunday 14th May 2017)"
	revision: "2"

deferred class
	EL_BUILDABLE_FROM_XML

inherit
	EL_BUILDABLE_FROM_NODE_SCAN

feature {NONE} -- Factory

	new_node_source: EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make ({EL_EXPAT_XML_PARSER})
		end
end
