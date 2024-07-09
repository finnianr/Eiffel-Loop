note
	description: "Object to analyse web-server log geographically according to configuration"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 19:54:02 GMT (Tuesday 9th July 2024)"
	revision: "23"

class
	EL_TRAFFIC_ANALYSIS_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_WEB_LOG_PARSER_COMMAND
		rename
			make as make_parser
		redefine
			execute
		end

	EL_MODULE_DATE; EL_MODULE_IP_ADDRESS

	EL_SHARED_IP_ADDRESS_GEOLOCATION

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: FILE_PATH; a_config: like config)
		do
			make_parser (a_log_path)
			config := a_config
			create page_table.make_equal (50)
			create bot_table.make_equal (50)
			create human_entry_list.make (500)
			across config.page_list as page loop
				page_table.extend_list (create {like page_table.item_list}.make (50), page.item)
			end
		end

feature -- Constants

	Description: STRING = "Analyse web traffic in from cherokee log file"

feature -- Basic operations

	execute
		do
			Precursor -- parse log file
			-- Cache locations
			lio.put_line ("Getting IP address locations:")
			IP_location_table.set_log (Lio)
			across human_entry_list as entry loop
				if across config.page_list as page some entry.item.request_uri.starts_with (page.item) end then
					call (IP_location_table.item (Ip_address.to_number (entry.item.ip_address)))
				end
			end
			IP_location_table.set_log (Void)
			lio.put_new_line_x2

			lio.put_line ("WEB CRAWLERS")
			across bot_table.as_sorted_list (False) as map loop
				lio.put_natural_field (map.key, map.value)
				lio.put_new_line
			end
			lio.put_new_line

			lio.put_line ("HUMANS")
			lio.put_new_line

			month_groups.linear_representation.do_all (agent print_month)
		end

feature {NONE} -- Implementation

	call (obj: ANY)
		do
		end

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			if is_bot (entry) then
				bot_table.put (entry.stripped_user_agent)
			else
				human_entry_list.extend (entry)
			end
		end

	entry_month (entry: EL_WEB_LOG_ENTRY): INTEGER
		do
			Result := entry.date.month + (entry.date.year - 2000) * 12
		end

	is_bot (entry: EL_WEB_LOG_ENTRY): BOOLEAN
		local
			user_agent: ZSTRING; buffer: EL_ZSTRING_BUFFER_ROUTINES
		do
			user_agent := buffer.copied (entry.user_agent)
			user_agent.to_lower
			Result := across config.crawler_substrings as substring some
				user_agent.has_substring (substring.item)
			end
		end

	month_groups: EL_FUNCTION_GROUP_TABLE [EL_WEB_LOG_ENTRY, INTEGER]
		do
			create Result.make_from_list (agent entry_month, human_entry_list)
		end

	print_month (entry_list: EL_ARRAYED_LIST [EL_WEB_LOG_ENTRY])
		local
			location_table: EL_COUNTER_TABLE [ZSTRING];found: BOOLEAN
		do
			across page_table.linear_representation as list loop
				list.item.wipe_out
			end
			across entry_list as entry loop
				found := False
				if entry.cursor_index = 1 then
					lio.put_labeled_string ("Month of", Date.long_month_name (entry.item.date).as_upper)
					lio.put_new_line_x2
				end
				across config.page_list as page until found loop
					if entry.item.request_uri.starts_with (page.item) then
						found := True
						if attached page_table [page.item] as list then
							list.extend (Ip_address.to_number (entry.item.ip_address))
						end
					end
				end
			end
			across page_table as page loop
				lio.put_integer_field (page.key, page.item.count)
				lio.put_new_line
				create location_table.make (page.item.count)
				across page.item as ip loop
					location_table.put (IP_location_table.item (ip.item))
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

	bot_table: EL_COUNTER_TABLE [ZSTRING]

	config: EL_TRAFFIC_ANALYSIS_CONFIG

	human_entry_list: ARRAYED_LIST [EL_WEB_LOG_ENTRY]

	page_table: EL_GROUP_TABLE [NATURAL, ZSTRING];

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