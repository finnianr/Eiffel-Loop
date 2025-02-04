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
	date: "2025-02-04 8:57:32 GMT (Tuesday 4th February 2025)"
	revision: "3"

class
	EL_URI_EXTENSION_404_ANALYSIS_COMMAND

inherit
	EL_URI_STEM_404_ANALYSIS_COMMAND
		redefine
			configuration_words_path, include_uri_part, make_default, uri_part
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create extension_set.make_from (config.extension_set, True)
		end

feature {NONE} -- Implementation

	configuration_words_path: FILE_PATH
		-- text file containing all `uri_part' that occur a minimum number of times specified by user
		do
			Result := config.text_output_dir + "match-has_extension.txt"
		end

	include_uri_part (a_uri_part: STRING): BOOLEAN
		do
			Result := not extension_set.has (a_uri_part)
		end

	uri_part (entry: EL_WEB_LOG_ENTRY): STRING
		do
			Result := entry.request_uri_extension
		end

feature {NONE} -- Internal attributes

	extension_set: EL_HASH_SET [STRING];

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