note
	description: "Post card viewer app"
	notes: "[
		Launch
			
			el_graphical -post_card_viewer
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 14:48:53 GMT (Saturday 5th February 2022)"
	revision: "9"

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

	gui: EL_VISION_2_USER_INTERFACE [POSTCARD_VIEWER_MAIN_WINDOW]

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