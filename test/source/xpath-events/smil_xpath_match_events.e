note
	description: "Summary description for {SMIL_XPATH_MATCH_EVENT_PROCESSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-06 10:31:55 GMT (Saturday 6th July 2013)"
	revision: "2"

class
	SMIL_XPATH_MATCH_EVENTS

inherit
	EL_CREATEABLE_FROM_XPATH_MATCH_EVENTS

	EL_MODULE_LOG

create
	make_from_file

feature {NONE} -- XPath match event handlers

	on_audio_title
			--
		do
			log.put_string_field ("AUDIO TITLE", last_node.to_string)
			log.put_new_line
		end

	on_meta_tag
			--
		do
			log.put_string_field ("META NAME", last_node.to_string)
			log.put_new_line
		end

	increment_audio_count
			--
		do
			count := count + 1
		end

	on_smil_end
			--
		do
			log.put_integer_field ("AUDIO COUNT", count)
			log.put_new_line
		end

feature {NONE} -- Implementation

	xpath_match_events: ARRAY [like Type_agent_mapping]
			--
		do
			Result := <<
				-- Fixed paths
				["/smil/body/seq/audio/@title", on_node_start, agent on_audio_title],

				["/smil", on_node_end, agent on_smil_end],

				-- Wild card paths
				["//audio", on_node_start, agent increment_audio_count],
				["//meta/@name", on_node_start, agent on_meta_tag]
			>>
		end

	count: INTEGER

end
