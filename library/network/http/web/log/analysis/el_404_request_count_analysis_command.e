note
	description: "[
		${EL_TRAFFIC_ANALYSIS_COMMAND} command to analyze uri requests with status 404 by
		geographic location of client.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-27 18:16:22 GMT (Monday 27th January 2025)"
	revision: "1"

class
	EL_404_REQUEST_COUNT_ANALYSIS_COMMAND

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
			request_counter_table: EL_COUNTER_TABLE [STRING]; occurrence_count: NATURAL
			request_list: EL_STRING_8_LIST
		do
			Precursor
			create request_counter_table.make (500)
			create request_list.make (50)

			across not_found_list as list loop
				if attached list.item as entry then
					request_counter_table.put (entry.request_stem_lower)
				end
			end
			lio.put_line ("CROPPED REQUEST URI")
			across request_counter_table.as_sorted_list (False) as map loop
				if occurrence_count /= map.value.item then
					if occurrence_count > 0 then
						display_occurrences (occurrence_count, request_list)
					end
					occurrence_count := map.value.item
				else
					request_list.extend (map.key)
				end
			end
			display_occurrences (occurrence_count, request_list)
		end

feature {NONE} -- Implementation

	display_occurrences (occurrence_count: NATURAL; request_list: EL_STRING_8_LIST)
		do
			if request_list.count > 0 then
				lio.put_natural_field ("OCCURRENCES", occurrence_count)
				lio.put_new_line
				display_sorted (request_list)
				lio.put_new_line
				request_list.wipe_out
			end
		end

end