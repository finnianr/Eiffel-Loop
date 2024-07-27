note
	description: "Compiles a set of language codes from a Pyxis translation source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 8:10:52 GMT (Saturday 27th July 2024)"
	revision: "2"

class
	EL_LANGUAGE_SET_READER

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS
		export
			{NONE} all
		end

	EL_PYXIS_PARSE_EVENT_TYPE

create
	make_from_file

feature {NONE} -- Initialization

	make_default
			--
		do
			create language_set.make (11)
		end

feature -- Access

	language_set: EL_HASH_SET [STRING]

feature {NONE} -- Implementation

	on_language_id
		do
			language_set.put (last_node.to_string_8)
		end

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := <<
				[on_open, "/translations/item/translation/@lang", agent on_language_id]
			>>
		end

end