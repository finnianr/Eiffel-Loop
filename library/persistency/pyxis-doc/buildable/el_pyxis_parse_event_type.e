note
	description: "Pyxis parse event type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-28 18:48:59 GMT (Wednesday 28th December 2022)"
	revision: "4"

class
	EL_PYXIS_PARSE_EVENT_TYPE

feature {NONE} -- Constants

	Parse_event_source_type: TYPE [EL_PARSE_EVENT_SOURCE]
		once
			Result := {EL_PYXIS_PARSER}
		end

end