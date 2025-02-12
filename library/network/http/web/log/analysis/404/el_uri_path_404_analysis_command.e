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
	date: "2025-02-12 14:59:18 GMT (Wednesday 12th February 2025)"
	revision: "6"

class
	EL_URI_PATH_404_ANALYSIS_COMMAND

inherit
	EL_URI_FIRST_STEP_404_ANALYSIS_COMMAND
		redefine
			configuration_words_path, include_uri_part, is_word_output, uri_part
		end

create
	make

feature {NONE} -- Implementation

	configuration_words_path: FILE_PATH
		-- text file containing all `uri_part' that occur a minimum number of times specified by user
		do
			Result := config.text_output_dir + "match-has_path.txt"
		end

	include_uri_part (uri_path: STRING): BOOLEAN
		do
			Result := across root_names_list as list all
				not uri_path.starts_with (list.item)
			end
		end

	is_word_output: BOOLEAN
		do
			Result := False
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