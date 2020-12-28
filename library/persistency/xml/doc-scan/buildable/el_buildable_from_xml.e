note
	description: "[
		Object buildable from node parse events generated by [$source EL_EXPAT_XML_PARSER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 10:17:25 GMT (Sunday 28th October 2018)"
	revision: "5"

deferred class
	EL_BUILDABLE_FROM_XML

inherit
	EL_BUILDABLE_FROM_NODE_SCAN

	EL_XML_PARSE_EVENT_TYPE

end