note
	description: "[
		Command to analyze URI requests with status 404 (not found) by frequency of the
		URI extension defined by function ${EL_WEB_LOG_ENTRY}.uri_extension.
		Saves selected extensions in `configuration_words_path' to help configure
		${EL_HACKER_INTERCEPT_CONFIG} import file.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-21 9:45:52 GMT (Friday 21st February 2025)"
	revision: "8"

class
	EL_URI_EXTENSION_404_ANALYSIS_COMMAND

inherit
	EL_URI_SUBSTRING_404_ANALYSIS_COMMAND
		rename
			root_names_list as extension_list,
			root_names_set as extension_set
		redefine
			extension_list, ask_to_filter_extensions
		end

create
	make

feature {NONE} -- Implementation

	ask_to_filter_extensions
		do
			do_nothing
		end

	excluded (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		-- `True' if entry should be excluded from report
		do
			Result := extension_set.has (entry.uri_extension)
		end

	extension_list: EL_STRING_8_LIST
		do
			create Result.make_multiline_words (config.site_extensions, ';', 0)
		end

	grid_column_count: INTEGER
		-- number of grid columns to display `uri_path'
		do
			Result := 6
		end

	grid_column_width: INTEGER
		-- maxium column width to display `uri_path' in grid columns
		do
			Result := 10
		end

	predicate_name: STRING
		-- predicate name for EL_URI_FILTER_TABLE
		do
			Result := Predicate.has_extension
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.uri_extension
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