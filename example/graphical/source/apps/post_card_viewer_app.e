note
	description: "Post card viewer app"
	notes: "[
		Launch
			
			el_graphical -post_card_viewer
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	POST_CARD_VIEWER_APP

inherit
	EL_LOGGED_APPLICATION

create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			create gui.make (False)
		end

feature -- Basic operations

	run
		do
			gui.launch
		end

feature {NONE} -- Implementation

	gui: EL_VISION_2_USER_INTERFACE [POSTCARD_VIEWER_MAIN_WINDOW, EL_STOCK_PIXMAPS]

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, POSTCARD_VIEWER_MAIN_WINDOW, POSTCARD_VIEWER_TAB
	]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Image viewer for post card sized images"
		end

end