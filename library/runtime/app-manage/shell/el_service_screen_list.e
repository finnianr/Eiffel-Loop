note
	description: "List of Unix service screens conforming to [$source EL_SERVICE_SCREEN]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 13:05:32 GMT (Friday 6th January 2023)"
	revision: "1"

class
	EL_SERVICE_SCREEN_LIST

inherit
	EL_ARRAYED_LIST [EL_SERVICE_SCREEN]

	EL_MODULE_NAMING

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
			Result := maximum_integer (agent name_count)
		end

feature -- Basic operations

	initialize (notification_email: ZSTRING)
		local
			name, option_name: ZSTRING
		do
			across Current as list loop
				name := list.item.name
				if name.is_empty then
					option_name := list.item.command_args.substring_to (' ', default_pointer)
					option_name.prune_all_leading ('-')
					name.append_string_general (Naming.class_description (option_name, Empty_string_8))
				end
				-- substitute $EMAIL
				across << list.item.bash_script, list.item.command_args >> as text loop
					text.item.replace_substring_all (Var_email, notification_email)
				end
			end
			replace_active
			order_by (agent {EL_SERVICE_SCREEN}.sort_name, True)
		end

feature {NONE} -- Implementation

	replace_active
		-- replace screens that are active with `ACTIVE_SERVICE_SCREEN'
		local
			list_cmd: EL_CAPTURED_OS_COMMAND; line_index: INTEGER
			id: STRING; name, line: ZSTRING
		do
			create list_cmd.make_with_name ("screen_list", "screen -list")
			list_cmd.set_success_code (256)
			list_cmd.execute

			-- Parse output of screen command
			across list_cmd.lines as list loop
				line := list.item
				if line.occurrences ('(').to_boolean and line.occurrences (')').to_boolean then
					line_index := 1
					id := line.substring_to ('.', $line_index)
					id.left_adjust
					name := line.substring_to ('(', $line_index)
					name.right_adjust
					find_first_equal (name, agent {like item}.name)
					if found then
						replace (create {EL_ACTIVE_SERVICE_SCREEN}.make (item, id.to_integer))
					end
				end
			end
		end

	name_count (screen: like item): INTEGER
		do
			Result := screen.name.count
		end

feature {NONE} -- Constants

	Var_email: ZSTRING
		once
			Result := "$EMAIL"
		end

end