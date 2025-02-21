note
	description: "[
		Command to analyze URI requests with status 404 (not found) by frequency of the
		request URI path defined by function ${EL_WEB_LOG_ENTRY}.uri_path.
		Saves selected extensions in `configuration_words_path' to help configure
		${EL_HACKER_INTERCEPT_CONFIG} import file.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-21 9:33:55 GMT (Friday 21st February 2025)"
	revision: "8"

class
	EL_URI_PATH_404_ANALYSIS_COMMAND

inherit
	EL_URI_SUBSTRING_404_ANALYSIS_COMMAND

create
	make

feature {NONE} -- Implementation

	excluded (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		-- `True' if entry should be excluded from report
		do
			Result := across root_names_list as list some
				entry.uri_path.starts_with (list.item)
			end
		end

	grid_column_count: INTEGER
		-- number of grid columns to display `uri_path'
		do
			Result := 1
		end

	grid_column_width: INTEGER
		-- maxium column width to display `uri_path' in grid columns
		do
			Result := 120
		end

	predicate_name: STRING
		-- predicate name for EL_URI_FILTER_TABLE
		do
			Result := "has_path"
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.uri_path
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
			_php
			phpm; pma
			webs; wp-l
	]"

end