note
	description: "Smil xpath match events"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-26 17:39:17 GMT (Wednesday 26th July 2023)"
	revision: "11"

class
	SMIL_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

	EL_XML_PARSE_EVENT_TYPE

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- Initialization

	make_default
		do
		end

feature {NONE} -- XPath match event handlers

	increment_audio_count
			--
		do
			count := count + 1
		end

	on_audio_title
			--
		do
			log.put_string_field ("AUDIO TITLE", last_node.adjusted (False))
			log.put_new_line
		end

	on_create
		do
			lio.put_labeled_string ("create", last_node.adjusted_8 (False))
			lio.put_new_line
		end

	on_meta_tag
			--
		do
			log.put_string_field ("META NAME", last_node.adjusted (False))
			log.put_new_line
		end

	on_smil_end
			--
		do
			log.put_integer_field ("AUDIO COUNT", count)
			log.put_new_line
		end

feature {NONE} -- Implementation

	count: INTEGER

	xpath_match_events: ARRAY [EL_XPATH_TO_AGENT_MAP]
			--
		do
			Result := <<
				-- Fixed paths
				[On_open, "/processing-instruction ('create')", agent on_create],
				[On_open, "/smil/body/seq/audio/@title", agent on_audio_title],

				[On_close, "/smil", agent on_smil_end],

				-- Wild card paths
				[On_open, "//audio", agent increment_audio_count],
				[On_open, "//meta/@name", agent on_meta_tag]
			>>
		end

end