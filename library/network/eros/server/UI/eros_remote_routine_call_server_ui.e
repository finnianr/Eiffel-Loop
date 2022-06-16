note
	description: "Remote routine call server ui"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 8:01:50 GMT (Thursday 16th June 2022)"
	revision: "9"

class
	EROS_REMOTE_ROUTINE_CALL_SERVER_UI

inherit
	EL_VISION_2_USER_INTERFACE [EROS_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW, EROS_STOCK_PIXMAPS]
		rename
			make as make_ui
		redefine
			new_window
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING; a_port_number, a_request_handler_count_max: INTEGER)
		do
			name := a_name; port_number := a_port_number; request_handler_count_max := a_request_handler_count_max
			make_ui (True)
		end

feature {NONE} -- Implementation

	new_window: EROS_REMOTE_ROUTINE_CALL_SERVER_MAIN_WINDOW
		do
			create Result.make
			Result.set_title (window_title)
			Result.set_connection_manager (port_number, request_handler_count_max)
		end

	window_title: STRING
			--
		do
			Result := "Server Monitor [" + name + "]"
		end

	name: STRING

	port_number, request_handler_count_max: INTEGER

feature {NONE} -- Constants

	SVG_pixmaps: ARRAY [EL_SVG_PIXMAP]
			--
		once
			create Result.make_empty
		end

end