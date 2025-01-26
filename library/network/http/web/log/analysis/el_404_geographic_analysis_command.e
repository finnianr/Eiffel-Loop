note
	description: "Generate report of 404 status requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-26 18:04:00 GMT (Sunday 26th January 2025)"
	revision: "2"

class
	EL_404_GEOGRAPHIC_ANALYSIS_COMMAND

inherit
	EL_TRAFFIC_ANALYSIS_COMMAND
		redefine
			execute, make_default, is_selected
		end

	EL_SHARED_HTTP_STATUS

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
			request_stem_set: EL_HASH_SET [ZSTRING]; request_list: EL_ZSTRING_LIST
			request_counter_table: EL_COUNTER_TABLE [ZSTRING]; occurrence_count: NATURAL
			ip_address_to_request_stem_map_list: EL_ARRAYED_MAP_LIST [NATURAL, ZSTRING]
		do
			Precursor
			create request_stem_set.make_equal (50)
			create request_counter_table.make (500)
			create request_list.make (50)
			create ip_address_to_request_stem_map_list.make (500)

		-- Cache locations
			lio.put_line ("Getting IP address locations:")

			Track.progress (Console_display, not_found_list.count, agent fill_location_grouped_entry_table)
			lio.put_new_line
			store_geolocation_data

			if attached location_grouped_entry_table as table then
				from table.start until table.after loop
					lio.put_labeled_string ("404 REQUESTS FROM", table.key_for_iteration)
					lio.put_new_line

					if attached table.item_for_iteration as entry_list then
						ip_address_to_request_stem_map_list.wipe_out
						request_stem_set.wipe_out
						across entry_list as list loop
							if attached list.item as entry and then attached entry.request_uri_stem as request_stem then
								request_counter_table.put (request_stem)
								request_stem_set.put (request_stem)
								ip_address_to_request_stem_map_list.extend (entry.ip_number, request_stem_set.found_item)
							end
						end

						ip_address_to_request_stem_map_list.sort_by_key_then_value (True, True)
						if attached {EL_GROUPED_SET_TABLE [ZSTRING, NATURAL]}
							ip_address_to_request_stem_map_list.to_grouped_set_table as uri_grouped_by_ip
						then
							across uri_grouped_by_ip as ip_group loop
								lio.put_line (Ip_address.to_string (ip_group.key))
								lio.put_labeled_string ("Agent", user_agent_table [ip_group.key])
								lio.put_new_line
								across ip_group.item as list loop
									if list.cursor_index > 1 then
										lio.put_string (Semicolon_space)
									end
									lio.put_string (list.item)
								end
								lio.put_new_line
							end
							lio.put_new_line
						end
					end
					table.forth
					lio.put_new_line
				end
			end
			if request_counter_table.count > 0 then
				User_input.press_enter
				lio.put_line ("CROPPED REQUEST URI")
				across request_counter_table.as_sorted_list (False) as map loop
					if occurrence_count /= map.value.item then
						if occurrence_count > 0 then
							display_sorted (occurrence_count, request_list)
						end
						occurrence_count := map.value.item
					else
						request_list.extend (map.key)
					end
				end
				display_sorted (occurrence_count, request_list)
			end
		end

feature {NONE} -- Implementation

	do_with (entry: EL_WEB_LOG_ENTRY)
		do
			if entry.status_code = Http_status.not_found then
				not_found_list.extend (entry)
			end
		end

	display_sorted (occurrence_count: NATURAL; request_list: EL_ZSTRING_LIST)
		do
			if request_list.count > 0 then
				lio.put_natural_field ("Occurrence count", occurrence_count)
				lio.put_new_line
				request_list.sort (True)
				across request_list as list loop
					if list.cursor_index > 1 then
						lio.put_string (Semicolon_space)
					end
					lio.put_string (list.item)
				end
				lio.put_new_line
				request_list.wipe_out
			end
		end

	fill_location_grouped_entry_table
		do
			across not_found_list as list loop
				if attached list.item as entry then
					location_grouped_entry_table.extend (entry.geographic_location, entry)
					user_agent_table.put (entry.user_agent, entry.ip_number)
				end
				progress_listener.notify_tick
			end
		end

	is_selected (line: ZSTRING): BOOLEAN
		do
			Result := line.has_substring (Separator_404)
		end

feature {NONE} -- Internal attributes

	location_grouped_entry_table: EL_GROUPED_SET_TABLE [EL_WEB_LOG_ENTRY, ZSTRING]

	user_agent_table: EL_HASH_TABLE [ZSTRING, NATURAL]
		-- look up user agent from IP number

feature {NONE} -- Constants

	Separator_404: STRING = " 404 "

	Semicolon_space: STRING = "; "
end