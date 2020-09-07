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
	date: "2020-09-07 8:42:03 GMT (Monday 7th September 2020)"
	revision: "6"

class
	POST_CARD_VIEWER_APP

inherit
	EL_LOGGED_SUB_APPLICATION

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

feature {NONE} -- Constants

	Description: STRING
		once
			Result := "Image viewer for post card sized images"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{POST_CARD_VIEWER_APP}, All_routines],
				[{POSTCARD_VIEWER_MAIN_WINDOW}, All_routines],
				[{POSTCARD_VIEWER_TAB}, All_routines]
			>>
		end

end
