note
	description: "[
		Object buildable from node parse events generated by [$source EL_PYXIS_PARSER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 17:03:04 GMT (Sunday 20th December 2020)"
	revision: "6"

deferred class
	EL_BUILDABLE_FROM_PYXIS

inherit
	EL_BUILDABLE_FROM_NODE_SCAN

	EL_PYXIS_PARSE_EVENT_TYPE

end