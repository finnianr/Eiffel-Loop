note
	description: "[
		Group sets of ${EL_WEB_LOG_ENTRY}.request_stem_uri by ${EL_WEB_LOG_ENTRY}.user_agent
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-30 7:30:00 GMT (Thursday 30th January 2025)"
	revision: "2"

class
	EL_REQUESTS_GROUPED_BY_USER_AGENT

inherit
	EL_GROUPED_SET_TABLE [STRING, STRING]
		rename
			extend as extend_table
		export
			{NONE} all
			{ANY} prunable
		redefine
			make, wipe_out
		end

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n)
			create counter_table.make (n)
		end

feature -- Basic operations

	display (user_prompt: BOOLEAN; label: STRING)
		local
			previous_count: NATURAL; l_string_list: EL_STRING_8_LIST
		do
			previous_count := previous_count.Max_value

			across counter_table.as_sorted_list (False) as agent_to_count_map loop
				if has_key (agent_to_count_map.key) then
					lio.put_natural (agent_to_count_map.value)
					lio.put_labeled_string (label, agent_to_count_map.key)
					lio.put_new_line

					create l_string_list.make_from_special (found_set.area)
					l_string_list.display_grouped (lio, 120)
					if user_prompt and then agent_to_count_map.value < previous_count then
						previous_count := agent_to_count_map.value
						User_input.press_enter
					end
				end
			end
		end

	extend (entry: EL_WEB_LOG_ENTRY)
		do
			if attached entry.normalized_user_agent as user_agent then
				counter_table.put (user_agent)
				extend_table (user_agent, entry.request_stem_lower)
			end
		end

	wipe_out
		do
			Precursor
			counter_table.wipe_out
		end

feature {NONE} -- Internal attributes

	counter_table: EL_COUNTER_TABLE [STRING]
end