note
	description: "[
		${EL_404_STATUS_ANALYSIS_COMMAND} command to analyze URI requests with
		status 404 (not found) by frequency of the normalize URI stem defined
		by function ${EL_WEB_LOG_ENTRY}.request_stem_lower
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-28 13:06:13 GMT (Tuesday 28th January 2025)"
	revision: "2"

class
	EL_REQUEST_COUNT_404_ANALYSIS_COMMAND

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
			lio.put_line ("REQUEST URI STEM OCCURRENCE FREQUENCY")
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
				request_list.display_grouped (lio)
				lio.put_new_line
				request_list.wipe_out
			end
		end

note
	notes: "[
		EXAMPLE REPORT
		(In descending order of request stem occurrence frequency)

			LOG LINE COUNTS
			Selected: 1098 Ignored: 3191

			CROPPED REQUEST URI OCCURRENCE FREQUENCY
			OCCURRENCES: 18
			css
			owa
			web; wp

			OCCURRENCES: 10
			_phpmyadmin
			phpmyadmin1; phpmyadmin2; phpmyadmin3; phpmyadmin4; phpmyadmin5; phpmyadmin_; pma
			website; wp-login.php
	]"

end