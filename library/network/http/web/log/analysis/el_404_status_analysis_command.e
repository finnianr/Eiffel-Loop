note
	description: "[
		${EL_TRAFFIC_ANALYSIS_COMMAND} command to analyze uri requests with status 404
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-27 18:17:35 GMT (Monday 27th January 2025)"
	revision: "1"

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

	display_sorted (request_list: EL_ARRAYED_LIST [STRING])
		local
			first_character: CHARACTER
		do
			if request_list.count > 0 then
				request_list.sort (True)
				if request_list.first.count > 0 then
					first_character := request_list.first [1]
				end
				across request_list as list loop
					if attached list.item as str then
						if list.cursor_index > 1 then
							if str.count > 0 and then first_character /= str [1] then
								lio.put_new_line
								first_character := str [1]
							else
								lio.put_string (Semicolon_space)
							end
						end
						lio.put_string (str)
					end
				end
				lio.put_new_line
			end
		end

	is_selected (line: STRING): BOOLEAN
		do
			Result := line.has_substring (Separator_404)
		end

feature {NONE} -- Constants

	Separator_404: STRING = " 404 "

	Semicolon_space: STRING = "; "
end