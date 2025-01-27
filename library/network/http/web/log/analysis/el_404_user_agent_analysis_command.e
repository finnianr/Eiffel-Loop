note
	description: "[
		${EL_TRAFFIC_ANALYSIS_COMMAND} command to analyze uri requests with status 404 by
		client user agent.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-27 18:16:58 GMT (Monday 27th January 2025)"
	revision: "1"

class
	EL_404_USER_AGENT_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute
		end

create
	make

feature -- Basic operations

	execute
		local
			request_stem_set: EL_HASH_SET [STRING]; user_agent_counter_table: EL_COUNTER_TABLE [STRING]
			user_agent_group_table: EL_GROUPED_SET_TABLE [STRING, STRING]
			group_count: INTEGER; previous_count: NATURAL
		do
			Precursor
			create request_stem_set.make_equal (500)
			group_count := (not_found_list.count // 20).max (20)
			create user_agent_counter_table.make (group_count)
			create user_agent_group_table.make (group_count)

			across not_found_list as list loop
				if attached list.item as entry then
					request_stem_set.put (entry.request_stem_lower)
					user_agent_counter_table.put (entry.user_agent)
					user_agent_group_table.extend (entry.user_agent, request_stem_set.found_item)
				end
			end

			previous_count := previous_count.Max_value

			across user_agent_counter_table.as_sorted_list (False) as agent_to_count_map loop
				if user_agent_group_table.has_key (agent_to_count_map.key) then
					lio.put_labeled_string ("AGENT", agent_to_count_map.key)
					lio.put_new_line
					lio.put_natural_field ("Total requests", agent_to_count_map.value)
					lio.put_new_line
					display_sorted (user_agent_group_table.found_set)
					if agent_to_count_map.value < previous_count then
						previous_count := agent_to_count_map.value
						User_input.press_enter
					end
				end
			end
		end

end