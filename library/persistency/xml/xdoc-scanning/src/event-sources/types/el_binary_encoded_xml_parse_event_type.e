note
	description: "Binary encoded xml parse event type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 10:29:54 GMT (Sunday 28th October 2018)"
	revision: "1"

class
	EL_BINARY_ENCODED_XML_PARSE_EVENT_TYPE

feature {NONE} -- Constants

	Parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}
		end

end
