note
	description: "[
		${EL_404_STATUS_ANALYSIS_COMMAND} command to analyze URI requests with
		status 404 (not found) by frequency of the normalized URI stem defined
		by function ${EL_WEB_LOG_ENTRY}.request_stem_lower
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-02 12:29:25 GMT (Sunday 2nd February 2025)"
	revision: "5"

class
	EL_URI_STEM_404_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute
		end

	EL_MODULE_NAMING

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
				request_counter_table.put (uri_part (list.item))
			end
			if attached Naming.class_with_separator (Current, ' ', 1, 3) as name then
				lio.put_substitution ("REQUEST %S OCCURRENCE FREQUENCY", [name])
				lio.put_new_line
			end
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
				lio.put_words (request_list, 100)
				lio.put_new_line
				request_list.wipe_out
			end
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.request_stem_lower
		end

note
	notes: "[
		EXAMPLE REPORT
		(In descending order of request stem occurrence frequency)

			LOG LINE COUNTS
			Selected: 1098 Ignored: 3191

			REQUEST URI EXTENSION OCCURRENCE FREQUENCY
			OCCURRENCES: 13
			.png

			OCCURRENCES: 4
			.git/config

			OCCURRENCES: 3
			.json; .shtml
	]"

end