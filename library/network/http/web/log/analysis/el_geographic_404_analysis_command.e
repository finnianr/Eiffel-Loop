note
	description: "[
		${EL_404_STATUS_ANALYSIS_COMMAND} command to analyze URI requests with status 404
		(not found) by geographic location.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-30 7:30:28 GMT (Thursday 30th January 2025)"
	revision: "5"

class
	EL_GEOGRAPHIC_404_ANALYSIS_COMMAND

inherit
	EL_404_STATUS_ANALYSIS_COMMAND
		redefine
			execute, make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create location_grouped_entry_table.make (1000)
			create user_agent_table.make_equal (500)
		end

feature -- Basic operations

	execute
		local
			user_agent_group_table: EL_REQUESTS_GROUPED_BY_USER_AGENT
			location_counter_table: EL_COUNTER_TABLE [ZSTRING]
			minimum_size: INTEGER
		do
			Precursor
			minimum_size := (not_found_list.count // 20).max (20)
			create user_agent_group_table.make (minimum_size)
			create location_counter_table.make_equal (minimum_size)

			across not_found_list as list loop
				if attached list.item as entry and then attached entry.geographic_location as location then
					location_grouped_entry_table.extend (location, entry)
					location_counter_table.put (location)
				end
			end
			lio.put_new_line

			across location_counter_table.as_sorted_list (False) as map loop
				if location_grouped_entry_table.has_key (map.key) then
					lio.put_natural (map.value)
					lio.put_labeled_string (" 404 REQUESTS FROM", map.key)
					lio.tab_right
					lio.put_new_line
					user_agent_group_table.wipe_out
					across location_grouped_entry_table.found_area as area loop
						user_agent_group_table.extend (area.item)
					end
					user_agent_group_table.display (False, " FROM AGENT")
					lio.tab_left
					lio.put_new_line
					User_input.press_enter
				end
			end
		end

feature {NONE} -- Internal attributes

	location_grouped_entry_table: EL_GROUPED_SET_TABLE [EL_WEB_LOG_ENTRY, ZSTRING]

	user_agent_table: EL_HASH_TABLE [STRING, NATURAL];
		-- look up user agent from IP number

note
	notes: "[
		EXAMPLE REPORT
		(In alphabetical order of country and user agent)

			404 REQUESTS FROM: Armenia
			AGENT: applewebkit edg nt win64 windows x64
			Total requests: 2
			login
			remote

			404 REQUESTS FROM: Australia
			AGENT: applewebkit nt win64 windows x64
			Total requests: 426
			alive.php; api
			backup; bc; bk; blog
			web; wordpress; wp; wp-includes; wp1
			AGENT: custom-asynchttpclient
			Total requests: 50
			phpunit; public
			testing; tests
			vendor
			workspace; ws; www
			yii
	]"

end