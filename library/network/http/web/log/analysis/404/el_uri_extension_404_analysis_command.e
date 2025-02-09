note
	description: "[
		Command to analyze URI requests with status 404 (not found) by frequency of the
		URI extension defined by function ${EL_WEB_LOG_ENTRY}.request_extension.
		Saves selected extensions in `configuration_words_path' to help configure
		${EL_HACKER_INTERCEPT_CONFIG} import file.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-09 11:14:39 GMT (Sunday 9th February 2025)"
	revision: "5"

class
	EL_URI_EXTENSION_404_ANALYSIS_COMMAND

inherit
	EL_URI_FIRST_STEP_404_ANALYSIS_COMMAND
		rename
			root_names_list as extension_list,
			root_names_set as extension_set
		redefine
			configuration_words_path, extension_list, include_uri_part, ask_to_filter_extensions, uri_part
		end

create
	make

feature {NONE} -- Implementation

	configuration_words_path: FILE_PATH
		-- text file containing all `uri_part' that occur a minimum number of times specified by user
		do
			Result := config.text_output_dir + "match-has_extension.txt"
		end

	extension_list: EL_STRING_8_LIST
		do
			create Result.make_multiline_words (config.site_extensions, ';', 0)
		end

	include_uri_part (uri_extension: STRING): BOOLEAN
		do
			Result := not extension_set.has (uri_extension)
		end

	ask_to_filter_extensions
		do
			do_nothing
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.request_uri_extension
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