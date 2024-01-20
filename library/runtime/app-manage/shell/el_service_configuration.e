note
	description: "Service management configuration for ${EL_SERVICE_MANAGER_SHELL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

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

	notification_email: ZSTRING

	screen_list: EL_SERVICE_SCREEN_LIST

feature {NONE} -- Event handler

	on_context_exit
		do
			screen_list.initialize (notification_email)
		end

feature {NONE} -- Constants

	Element_node_fields: STRING = "screen_list"

end