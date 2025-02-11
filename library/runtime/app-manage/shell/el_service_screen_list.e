note
	description: "List of Unix service screens conforming to ${EL_SERVICE_SCREEN}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-11 6:28:15 GMT (Tuesday 11th February 2025)"
	revision: "9"

class
	EL_SERVICE_SCREEN_LIST

inherit
	EL_ARRAYED_LIST [EL_SERVICE_SCREEN]
		rename
			initialize as initialize_list
		end

	EL_STRING_8_CONSTANTS

create
	make

feature -- Measurement

	active_count: INTEGER
		do
			Result := count_of (agent {like item}.is_active)
		end

	longest_name_count: INTEGER
		do
			Result := max_integer (agent name_count)
		end

feature -- Basic operations

	initialize (variable_table: EL_ZSTRING_TABLE)
		do
			across Current as list loop
				list.item.set_default_name
			-- expand $EMAIL and $DOMAIN variables
				list.item.expand_command_args (variable_table)
			end
			replace_active
			order_by (agent {EL_SERVICE_SCREEN}.sort_name, True)
		end

feature {NONE} -- Implementation

	replace_active
		-- replace screens that are active with `ACTIVE_SERVICE_SCREEN'
		local
			screen_list: EL_SCREEN_SESSIONS_COMMAND
		do
			create screen_list.make
			screen_list.execute
			across screen_list.session_list as list loop
				if attached list.item as session then
					find_first_equal (session.name, agent {like item}.name)
					if found then
						replace (create {EL_ACTIVE_SERVICE_SCREEN}.make (item, session.id))
					end
				end
			end
		end

	name_count (screen: like item): INTEGER
		do
			Result := screen.name.count
		end

end