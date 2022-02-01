note
	description: "Service management configuration for [$source EL_SERVICE_MANAGER_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 9:36:01 GMT (Tuesday 1st February 2022)"
	revision: "2"

class
	EL_SERVICE_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			element_node_fields as Empty_set,
			make_from_file as make
		redefine
			initialize_fields, new_instance_functions, on_context_exit
		end

	EL_MODULE_NAMING

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			create screen_list.make (10)
		end

feature -- Measurement

	screen_count: INTEGER
		do
			Result := screen_list.count
		end

	active_screen_count: INTEGER
		do
			across screen_list as list loop
				if attached {EL_ACTIVE_SERVICE_SCREEN} list.item then
					Result := Result + 1
				end
			end
		end

	longest_name_count: INTEGER
		do
			across screen_list as list loop
				if list.item.name.count > Result then
					Result := list.item.name.count
				end
			end
		end

feature -- Configuration fields

	notification_email: ZSTRING

	screen_list: EL_ARRAYED_LIST [EL_SERVICE_SCREEN]

feature {NONE} -- Event handler

	on_context_exit
			-- Called when the Pyxis parser leaves the current context
		local
			name, option_name: ZSTRING
		do
			across screen_list as list loop
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
			screen_list.order_by (agent {EL_SERVICE_SCREEN}.sort_name, True)
		end

feature {NONE} -- Implementation

	new_instance_functions: like Default_initial_values
		do
			create Result.make_from_array (<<
				agent: like screen_list.item do create Result.make_default end
			>>)
		end

	replace_active
		-- replace screens that are active with `ACTIVE_SERVICE_SCREEN'
		local
			list_cmd: EL_CAPTURED_OS_COMMAND; index: INTEGER
			id: STRING; name, line: ZSTRING
		do
			create list_cmd.make_with_name ("screen_list", "screen -list")
			list_cmd.set_success_code (256)
			list_cmd.execute

			-- Parse output of screen command
			across list_cmd.lines as list loop
				line := list.item
				if line.occurrences ('(').to_boolean and line.occurrences (')').to_boolean then
					index := 1
					id := line.substring_to ('.', $index)
					id.left_adjust
					name := line.substring_to ('(', $index)
					name.right_adjust
					screen_list.find_first_equal (name, agent {EL_SERVICE_SCREEN}.name)
					if screen_list.found then
						screen_list.replace (create {EL_ACTIVE_SERVICE_SCREEN}.make (screen_list.item, id.to_integer))
					end
				end
			end
		end

feature {NONE} -- Constants

	Var_email: ZSTRING
		once
			Result := "$EMAIL"
		end

end