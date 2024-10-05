note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "13"

class
	TOKENIZED_FILE_SIZE_SCANNER

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

	FILE_SIZE_SCANNER
		rename
			node as last_node
		end

	EL_XML_PARSE_EVENT_TYPE

create
	make

feature {NONE} -- Initialization

	make_default
		do
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := <<
				[On_open, "/rhythmdb/entry/file-size/text()", agent increment_size_count]
			>>
		end

end