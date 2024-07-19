note
	description: "Test class ${EL_UNDOABLE_TEXT_COMPONENT}"
	notes: "[
		Usage:
			el_graphical -edit_history_test

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-19 6:41:21 GMT (Friday 19th July 2024)"
	revision: "1"

class
	EDIT_HISTORY_TEST_APP

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

	gui: EL_VISION_2_USER_INTERFACE [TEXT_EDITOR_MAIN_WINDOW, EL_STOCK_PIXMAPS]

	log_filter_set: EL_LOG_FILTER_SET [like Current, TEXT_EDITOR_MAIN_WINDOW]
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING = "Test edit history for text components"

end