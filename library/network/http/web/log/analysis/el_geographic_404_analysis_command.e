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
	date: "2025-01-28 13:13:49 GMT (Tuesday 28th January 2025)"
	revision: "4"

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
		do
			Precursor
			create user_agent_group_table.make ((not_found_list.count // 20).max (20))

			across not_found_list as list loop
				if attached list.item as entry then
					location_grouped_entry_table.extend (entry.geographic_location, entry)
				end
			end
			lio.put_new_line

			if attached location_grouped_entry_table as table then
				table.sort_by_key (True)
				from table.start until table.after loop
					lio.put_labeled_string ("404 REQUESTS FROM", table.key_for_iteration)
					lio.put_new_line
					user_agent_group_table.wipe_out
					across table.item_area_for_iteration as list loop
						user_agent_group_table.extend (list.item)
					end
					user_agent_group_table.display (False)
					User_input.press_enter
					table.forth
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