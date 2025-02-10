note
	description: "Service management configuration for ${EL_SERVICE_MANAGER_SHELL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-10 16:36:47 GMT (Monday 10th February 2025)"
	revision: "13"

class
	EL_SERVICE_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			make_from_file as make
		redefine
			on_context_exit
		end

	EL_STRING_GENERAL_ROUTINES

create
	make

feature -- Configuration fields

	domain: ZSTRING

	notification_email: ZSTRING

	screen_list: EL_SERVICE_SCREEN_LIST

feature -- Status query

	is_deployed: BOOLEAN

feature {NONE} -- Event handler

	on_context_exit
		local
			host: EL_HOST_NAME_COMMAND
		do
			create host.make
			is_deployed := domain.same_string_general (host.name)
		-- remove any developer entries on deployment server
			if is_deployed and then attached screen_list as list then
				from list.start until list.after loop
					if list.item.developer then
						list.remove
					else
						list.forth
					end
				end
			end
			screen_list.initialize (new_variable_table)
		end

feature {NONE} -- Factory

	new_variable_table: EL_ZSTRING_TABLE
		do
			create Result.make_assignments (<<
				["$EMAIL",		  notification_email],
				["$DOMAIN",		  domain],
				["$TEST_OPTION", test_option]
			>>)
		end

feature {NONE} -- Implementation

	test_option: ZSTRING
		do
			Result := if is_deployed then Empty_string else ZSTRING ("-test") end
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "screen_list"

end