note
	description: "XML parse event type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-21 11:29:32 GMT (Monday 21st December 2020)"
	revision: "2"

class
	EL_XML_PARSE_EVENT_TYPE

feature {NONE} -- Constants

	Parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_EXPAT_XML_PARSER}
		end
end