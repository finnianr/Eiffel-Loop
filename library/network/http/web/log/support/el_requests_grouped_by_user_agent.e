note
	description: "[
		Group sets of ${EL_WEB_LOG_ENTRY}.request_stem_uri by ${EL_WEB_LOG_ENTRY}.user_agent
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-02 12:29:14 GMT (Sunday 2nd February 2025)"
	revision: "5"

class
	EL_REQUESTS_GROUPED_BY_USER_AGENT

inherit
	EL_GROUPED_SET_TABLE [STRING, STRING]
		rename
			extend as extend_table
		export
			{NONE} all
			{ANY} prunable, wipe_out
		end

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

create
	make

feature -- Basic operations

	display (user_prompt: BOOLEAN; label: STRING)
		local
			previous_count: INTEGER; l_string_list: EL_STRING_8_LIST
		do
			previous_count := previous_count.Max_value
			sort_by_item_count (False) -- user agents with most requests at top
			from start until after loop
				if attached key_for_iteration as user_agent
					and then attached item_area_for_iteration as request_array
				then
					lio.put_integer (request_array.count)
					lio.put_labeled_string (label, user_agent)
					lio.put_new_line

					create l_string_list.make_from_special (request_array)
					lio.put_words (l_string_list, 120)
					if user_prompt and then request_array.count < previous_count then
						previous_count := request_array.count
						User_input.press_enter
					end
				end
				forth
			end
		end

	extend (entry: EL_WEB_LOG_ENTRY)
		do
			extend_table (entry.normalized_user_agent, entry.request_stem_lower)
		end

end