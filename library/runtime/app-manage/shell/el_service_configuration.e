note
	description: "Service management configuration for [$source EL_SERVICE_MANAGER_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 12:44:36 GMT (Friday 6th January 2023)"
	revision: "7"

class
	EL_SERVICE_CONFIGURATION

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			field_included as is_any_field,
			element_node_fields as Empty_set,
			make_from_file as make
		redefine
			on_context_exit
		end

create
	make

feature -- Configuration fields

	notification_email: ZSTRING

	screen_list: EL_SERVICE_SCREEN_LIST

feature {NONE} -- Event handler

	on_context_exit
		do
			screen_list.initialize (notification_email)
		end

end