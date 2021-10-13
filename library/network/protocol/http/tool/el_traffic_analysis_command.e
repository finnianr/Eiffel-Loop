note
	description: "Object to analyse web-server log geographically according to configuration"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-12 18:37:11 GMT (Tuesday 12th October 2021)"
	revision: "9"

class
	EL_TRAFFIC_ANALYSIS_COMMAND

inherit
	EL_WEB_LOG_PARSER_COMMAND
		rename
			make as make_parser
		redefine
			execute
		end

	EL_MODULE_DATE

	EL_SHARED_IP_ADDRESS_INFO_TABLE

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_log_path: EL_FILE_PATH; a_config: like config)
		do
			make_parser (a_log_path)
			config := a_config
			create page_table.make_equal (50)
			create bot_table.make_equal (50)
			create human_entry_list.make (500)
			across config.page_list as page loop
				page_table.extend (create {ARRAYED_LIST [NATURAL]}.make (50), page.item)
			end
		end

feature -- Basic operations

	execute
		do
			Precursor
			-- Cache locations
			lio.put_line ("Getting IP address locations:")
			Internet_address.set_log (Lio)
			across human_entry_list as entry loop
				if across config.page_list as page some entry.item.request_uri.starts_with (page.item) end then
					call (Internet_address.item (entry.item.ip_address).location)
				end
			end
			Internet_address.set_log (Void)
			lio.put_new_line_x2

			lio.put_line ("WEB CRAWLERS")
			across bot_table.as_sorted_list (False) as map loop
				lio.put_natural_field (map.item.key, map.item.value)
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
				bot_table.put (entry.versionless_user_agent)
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

	month_groups: EL_GROUP_TABLE [EL_WEB_LOG_ENTRY, INTEGER]
		do
			create Result.make_from_list (agent entry_month, human_entry_list)
		end

	print_month (entry_list: EL_ARRAYED_LIST [EL_WEB_LOG_ENTRY])
		local
			location_table: EL_COUNTER_TABLE [ZSTRING]
			found: BOOLEAN
		do
			page_table.linear_representation.do_all (agent {like page_table.item}.wipe_out)
			across entry_list as entry loop
				found := False
				if entry.cursor_index = 1 then
					lio.put_line (Month_heading #$ [Date.long_month_name (entry.item.date).as_upper])
					lio.put_new_line
				end
				across config.page_list as page until found loop
					if entry.item.request_uri.starts_with (page.item) then
						found := True
						if page_table.has_key (page.item) then
							page_table.found_item.extend (entry.item.ip_address)
						end
					end
				end
			end
			across page_table as page loop
				lio.put_integer_field (page.key, page.item.count)
				lio.put_new_line
				create location_table.make (page.item.count)
				across page.item as ip loop
					location_table.put (Internet_address.item (ip.item).location)
				end
				across location_table.as_sorted_list (False) as map loop
					lio.tab_right
					lio.put_new_line
					lio.put_natural_field (map.item.key, map.item.value)
					lio.tab_left
				end
				lio.put_new_line_x2
			end
		end

feature {NONE} -- Internal attributes

	bot_table: EL_COUNTER_TABLE [ZSTRING]

	config: EL_TRAFFIC_ANALYSIS_CONFIG

	human_entry_list: ARRAYED_LIST [EL_WEB_LOG_ENTRY]

	page_table: EL_ZSTRING_HASH_TABLE [ARRAYED_LIST [NATURAL]]

feature {NONE} -- Constants

	Month_heading: ZSTRING
		once
			Result := "* %S *"
		end

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