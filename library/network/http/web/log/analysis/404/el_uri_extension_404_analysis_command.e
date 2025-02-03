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
	date: "2025-02-03 14:42:05 GMT (Monday 3rd February 2025)"
	revision: "2"

class
	EL_URI_EXTENSION_404_ANALYSIS_COMMAND

inherit
	EL_URI_STEM_404_ANALYSIS_COMMAND
		redefine
			configuration_words_path, uri_part
		end

create
	make

feature {NONE} -- Implementation

	configuration_words_path: FILE_PATH
		-- text file containing all `uri_part' that occur a minimum number of times specified by user
		do
			Result := config.text_output_dir + "match-has_extension.txt"
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