note
	description: "[
		${EL_TRAFFIC_ANALYSIS_COMMAND} command to analyze uri requests with status 404
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-28 10:01:38 GMT (Tuesday 28th January 2025)"
	revision: "2"

class
	EL_404_STATUS_ANALYSIS_COMMAND

inherit
	EL_TRAFFIC_ANALYSIS_COMMAND
		redefine
			is_selected
		end

	EL_SHARED_HTTP_STATUS

feature {NONE} -- Implementation

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			if entry.status_code = Http_status.not_found then
				not_found_list.extend (entry)
				entry.cache_location
			end
		end

feature {NONE} -- Implementation

	is_selected (line: STRING): BOOLEAN
		do
			Result := line.has_substring (Separator_404)
		end

feature {NONE} -- Constants

	Separator_404: STRING = " 404 "
end