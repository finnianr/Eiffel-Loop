note
	description: "[
		${EL_TRAFFIC_ANALYSIS_COMMAND} command to analyze uri requests with status 404 by
		geographic location of client.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-27 18:20:00 GMT (Monday 27th January 2025)"
	revision: "3"

class
	EL_404_GEOGRAPHIC_ANALYSIS_COMMAND

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
			request_stem_set: EL_HASH_SET [STRING]; request_list: EL_STRING_8_LIST
			ip_address_to_request_stem_map_list: EL_ARRAYED_MAP_LIST [NATURAL, STRING]
		do
			Precursor
			create request_stem_set.make_equal (50)
			create request_list.make (50)
			create ip_address_to_request_stem_map_list.make (500)

			across not_found_list as list loop
				if attached list.item as entry then
					location_grouped_entry_table.extend (entry.geographic_location, entry)
					user_agent_table.put (entry.user_agent, entry.ip_number)
				end
			end
			lio.put_new_line

			if attached location_grouped_entry_table as table then
				from table.start until table.after loop
					lio.put_labeled_string ("404 REQUESTS FROM", table.key_for_iteration)
					lio.put_new_line

					if attached table.item_for_iteration as entry_list then
						ip_address_to_request_stem_map_list.wipe_out
						request_stem_set.wipe_out
						across entry_list as list loop
							if attached list.item as entry and then attached entry.request_stem_lower as request_stem then
								request_stem_set.put (request_stem)
								ip_address_to_request_stem_map_list.extend (entry.ip_number, request_stem_set.found_item)
							end
						end

						ip_address_to_request_stem_map_list.sort_by_key_then_value (True, True)
						if attached {EL_GROUPED_SET_TABLE [STRING, NATURAL]}
							ip_address_to_request_stem_map_list.to_grouped_set_table as uri_grouped_by_ip
						then
							across uri_grouped_by_ip as ip_group loop
								lio.put_line (Ip_address.to_string (ip_group.key))
								lio.put_labeled_string ("Agent", user_agent_table [ip_group.key])
								lio.put_new_line
								display_sorted (ip_group.item)
							end
							lio.put_new_line
						end
					end
					table.forth
				end
			end
		end

feature {NONE} -- Internal attributes

	location_grouped_entry_table: EL_GROUPED_SET_TABLE [EL_WEB_LOG_ENTRY, ZSTRING]

	user_agent_table: EL_HASH_TABLE [STRING, NATURAL]
		-- look up user agent from IP number
end