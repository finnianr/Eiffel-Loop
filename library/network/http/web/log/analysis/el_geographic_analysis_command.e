note
	description: "[
		Command to analyse web-server log geographically according to configuration
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-24 14:17:44 GMT (Friday 24th January 2025)"
	revision: "33"

class
	EL_GEOGRAPHIC_ANALYSIS_COMMAND

inherit
	EL_WEB_LOG_PARSER_COMMAND
		redefine
			execute, make_default, is_selected
		end

	EL_SHARED_FORMAT_FACTORY

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_config: like config)
		do
			config := a_config
			make_default
			across config.page_list as page loop
				page_table.extend_area (create {SPECIAL [NATURAL]}.make_empty (50), page.item)
			end
		end

	make_default
		do
			Precursor
			create buffer
			create page_table.make_equal (50)
			create bot_agent_table.make_equal (50)
			create last_uri_stem.make_empty
			create human_agent_table.make_equal (50)
			create human_entry_list.make (500)
		end

feature -- Basic operations

	execute
		local
			mobile_count, mobile_proportion: INTEGER
		do
			Precursor -- parse log file

		-- Cache locations
			lio.put_line ("Getting IP address locations:")

			Track.progress (Console_display, human_entry_list.count, agent fill_human_agent_table)

			lio.put_new_line
			store_geolocation_data

			across << bot_agent_table, human_agent_table >> as table loop
				if table.cursor_index = 1 then
					lio.put_line ("WEB CRAWLER AGENTS")
				else
					lio.put_line ("HUMAN AGENTS")
				end
				across table.item.as_sorted_list (False) as map loop
					lio.put_natural_field (map.key, map.value)
					lio.put_new_line
				end
				lio.put_new_line
				User_input.press_enter
			end

			lio.put_line ("SELECTED HUMAN VISITS")
			lio.put_new_line
			month_groups.item_area_set.do_all (agent print_month)

			if not_found_list.count > 0 then
				lio.put_line ("HUMAN REQUESTS NOT FOUND")
				across not_found_list as list loop
					if attached list.item as entry then
						lio.put_string_field (entry.status_code.out,entry.request_uri)
						lio.put_new_line
					end
				end
				User_input.press_enter
				lio.put_new_line
			end

		-- Percentage visits from mobile devices
			if human_entry_list.count > 0 then
				mobile_count := human_entry_list.count_of (agent {EL_WEB_LOG_ENTRY}.has_mobile_agent)
				mobile_proportion := (mobile_count * 100) // human_entry_list.count
				lio.put_labeled_string ("Mobile traffic", Format.integer_as_string (mobile_proportion, "99%%"))
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			if is_bot (entry) then
				bot_agent_table.put (entry.stripped_user_agent)

			elseif entry.status_code = 200 then
				human_entry_list.extend (entry)
			-- Mark entries that match one of `config.page_list'
				entry.set_request_uri_group (last_uri_stem)
			else
				not_found_list.extend (entry)
			end
		end

	entry_month (entry: EL_WEB_LOG_ENTRY): INTEGER
		do
			Result := entry.compact_date |>> 8
		end

	fill_human_agent_table
		-- fill `human_agent_table' and cache geolocations
		do
			across human_entry_list as list loop
				if attached list.item as entry and then attached Geolocation.for_number (entry.ip_number) then
					human_agent_table.put (entry.stripped_user_agent)
					progress_listener.notify_tick
				end
			end
		end

	is_bot (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		local
			user_agent: ZSTRING
		do
			user_agent := buffer.copied (entry.user_agent)
			user_agent.to_lower
			Result := across config.crawler_substrings as substring some
				user_agent.has_substring (substring.item)
			end
		end

	is_selected (line: ZSTRING): BOOLEAN
		local
			uri_index: INTEGER
		do
			uri_index := index_of_request_uri (line)
			if uri_index > 0 then
				across config.page_list as page until Result loop
					if attached page.item as uri_stem then
						if line.same_characters (uri_stem, 1, uri_stem.count, uri_index) then
							last_uri_stem := uri_stem
							Result := True
						end
					end
				end
			end
		end

	month_groups: EL_FUNCTION_GROUPED_SET_TABLE [EL_WEB_LOG_ENTRY, INTEGER]
		do
			create Result.make_from_list (agent entry_month, human_entry_list)
		end

	print_month (entry_list: SPECIAL [EL_WEB_LOG_ENTRY])
		local
			location_table: EL_COUNTER_TABLE [ZSTRING]; found: BOOLEAN
		do
			page_table.wipe_out_sets

			across entry_list as list loop
				if attached list.item as entry then
					found := False
					if list.cursor_index = 1 then
						lio.put_labeled_string ("-- MONTH", entry.month_year)
						lio.put_string (" --")
						lio.put_new_line_x2
					end
					page_table.extend (entry.request_uri_group, entry.ip_number)
				end
			end
			across page_table as page loop
				lio.put_integer_field (page.key, page.item.count)
				lio.put_new_line
				create location_table.make (page.item.count)
				across page.item as ip loop
					location_table.put (Geolocation.for_number (ip.item))
				end
				across location_table.as_sorted_list (False) as map loop
					lio.tab_right
					lio.put_new_line
					lio.put_natural_field (map.key, map.value)
					lio.tab_left
				end
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Internal attributes

	bot_agent_table: EL_COUNTER_TABLE [ZSTRING]

	buffer: EL_ZSTRING_BUFFER

	config: EL_TRAFFIC_ANALYSIS_CONFIG

	human_agent_table: EL_COUNTER_TABLE [ZSTRING]

	human_entry_list: EL_QUERYABLE_ARRAYED_LIST [EL_WEB_LOG_ENTRY]

	last_uri_stem: ZSTRING

	page_table: EL_GROUPED_SET_TABLE [NATURAL, ZSTRING];

note
	notes: "[
		**Example Configuration**
		
			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			traffic_analysis_config:
				page_list:
					item:
						"/en/download/latest-version.html"
						"/en/purchase/purchase-a-subscription.html"
					item:
						"/download/install_my_ching.sh"
						"/download/MyChing-en-win32"
						"/download/MyChing-en-win64"

				crawler_substrings:
					item:
						"archiver"
						"bot"
						"crawl"
						"dataprovider"
						"facebookexternalhit"
						"go-http-client"
						"ips-agent"
						"libwww"
						"researchscan"
						"spider"
						"netcraftsurveyagent"
						"python"
						"qwantify"
	]"

end