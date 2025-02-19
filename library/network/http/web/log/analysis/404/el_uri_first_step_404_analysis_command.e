note
	description: "[
		Command to analyze URI requests with status 404 (not found) by frequency of the
		normalized URI stem defined by function ${EL_WEB_LOG_ENTRY}.request_stem_lower.
		Saves selected URI-stems in `configuration_words_path' to help configure
		${EL_HACKER_INTERCEPT_CONFIG} import file.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-19 17:47:04 GMT (Wednesday 19th February 2025)"
	revision: "13"

class
	EL_URI_FIRST_STEP_404_ANALYSIS_COMMAND

inherit
	EL_URI_SUBSTRING_404_ANALYSIS_COMMAND

create
	make

feature {NONE} -- Implementation

	grid_column_count: INTEGER
		-- number of grid columns to display `uri_path'
		do
			Result := 120 // grid_column_width
		end

	grid_column_width: INTEGER
		-- maxium column width to display `uri_path' in grid columns
		do
			Result := 15
		end

	include_uri_part (uri_first_step: STRING): BOOLEAN
		do
			Result := not root_names_set.has (uri_first_step)
		end

	predicate_name: STRING
		-- predicate name for EL_URI_FILTER_TABLE
		do
			Result := Predicate.first_step
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.uri_step
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