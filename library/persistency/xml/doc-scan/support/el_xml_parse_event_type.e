note
	description: "XML parse event type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 9:04:59 GMT (Friday 6th January 2023)"
	revision: "4"

deferred class
	EL_XML_PARSE_EVENT_TYPE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_EXPAT_XML_PARSER}
		end
end