note
	description: "[
		${EL_404_STATUS_ANALYSIS_COMMAND} command to analyze URI requests with
		status 404 (not found) by frequency of the URI extension defined
		by function ${EL_WEB_LOG_ENTRY}.request_extension
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-01 9:18:25 GMT (Saturday 1st February 2025)"
	revision: "1"

class
	EL_URI_EXTENSION_404_ANALYSIS_COMMAND

inherit
	EL_URI_STEM_404_ANALYSIS_COMMAND
		redefine
			uri_part
		end

create
	make

feature {NONE} -- Implementation

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