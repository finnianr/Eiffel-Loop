note
	description: "Generate report of 404 status requests"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-24 15:49:06 GMT (Friday 24th January 2025)"
	revision: "1"

class
	EL_404_ANALYSIS_COMMAND

inherit
	EL_WEB_LOG_PARSER_COMMAND
		rename
			make_default as make
		redefine
			execute, make, is_selected
		end

	EL_SHARED_HTTP_STATUS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create ip_grouped_entry_table.make (1000)
		end

feature -- Basic operations

	execute
		local
			user_agent_set: EL_HASH_SET [ZSTRING]; request_list: EL_ZSTRING_LIST
			request_counter_table: EL_COUNTER_TABLE [ZSTRING]; occurrence_count: NATURAL
		do
			Precursor
			create user_agent_set.make_equal (50)
			create request_counter_table.make (500)
			create request_list.make (50)

		-- Cache locations
			lio.put_line ("Getting IP address locations:")

			Track.progress (Console_display, not_found_list.count, agent fill_ip_grouped_entry_table)
			lio.put_new_line
			store_geolocation_data

			if attached ip_grouped_entry_table as table then
				from table.start until table.after loop
					if attached table.item_for_iteration as entry_list
						and then attached table.key_for_iteration as ip_number
					then
						lio.put_labeled_string (Ip_address.to_string (ip_number), Geolocation.for_number (ip_number))
						lio.put_new_line
						user_agent_set.wipe_out
						across entry_list as list loop
							if list.cursor_index = 1 then
								lio.put_line (list.item.user_agent)
							end
							if attached cropped_user_agent (list.item.request_uri) as request_stem then
								user_agent_set.put (request_stem)
								request_counter_table.put (request_stem)
							end
						end
						if attached user_agent_set.to_list as user_agent_list then
							user_agent_list.sort (True)
							across user_agent_list as list loop
								if list.cursor_index > 1 then
									lio.put_string (Semicolon_space)
								end
								lio.put_string (list.item)
							end
							lio.put_new_line
						end
					end
					table.forth
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

	cropped_user_agent (str: ZSTRING): ZSTRING
		local
			slash_2_index: INTEGER
		do
			Result := str.substring_to ('?')
			if str.count > 2 and then str.item_8 (1) = '/' then
				slash_2_index := str.index_of ('/', 2)
				if slash_2_index > 0 then
					Result.keep_head (slash_2_index - 1)
				end
			end
		end

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

	fill_ip_grouped_entry_table
		do
			across not_found_list as list loop
				if attached list.item as entry and then attached Geolocation.for_number (entry.ip_number) then
					ip_grouped_entry_table.extend (entry.ip_number, entry)
					progress_listener.notify_tick
				end
			end
		end

	is_selected (line: ZSTRING): BOOLEAN
		do
			Result := line.has_substring (Separator_404)
		end

feature {NONE} -- Internal attributes

	ip_grouped_entry_table: EL_GROUPED_SET_TABLE [EL_WEB_LOG_ENTRY, NATURAL]

feature {NONE} -- Constants

	Separator_404: STRING = " 404 "

	Semicolon_space: STRING = "; "
end