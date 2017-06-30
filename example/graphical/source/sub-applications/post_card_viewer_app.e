note
	description: "Summary description for {POST_CARD_VIEWER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 14:18:06 GMT (Thursday 29th June 2017)"
	revision: "2"

class
	POST_CARD_VIEWER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

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

	gui: EL_VISION2_USER_INTERFACE [POSTCARD_VIEWER_MAIN_WINDOW]

feature {NONE} -- Constants

	Option_name: STRING
		once
			Result := "postcards"
		end

	Description: STRING
		once
			Result := "Image viewer for post card sized images"
		end

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{POST_CARD_VIEWER_APP}, "*"],
				[{POSTCARD_VIEWER_MAIN_WINDOW}, "*"],
				[{POSTCARD_VIEWER_TAB}, "*"]
			>>
		end

end
