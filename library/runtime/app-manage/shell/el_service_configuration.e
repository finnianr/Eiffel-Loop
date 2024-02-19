note
	description: "Service management configuration for ${EL_SERVICE_MANAGER_SHELL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-17 18:10:13 GMT (Saturday 17th February 2024)"
	revision: "10"

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

create
	make

feature -- Configuration fields

	domain: ZSTRING

	notification_email: ZSTRING

	screen_list: EL_SERVICE_SCREEN_LIST

feature {NONE} -- Event handler

	on_context_exit
		do
			screen_list.initialize (new_variable_table)
		end

feature {NONE} -- Factory

	new_variable_table: EL_ZSTRING_TABLE
		do
			create Result.make_from_array (<<
				["$EMAIL",	notification_email],
				["$DOMAIN",	domain]
			>>)
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "screen_list"

end