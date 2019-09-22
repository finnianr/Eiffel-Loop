note
	description: "[
		Thread for file serialization with progress notification
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-19 21:36:41 GMT (Thursday   19th   September   2019)"
	revision: "6"

class
	EL_FILE_PROCESS_THREAD

inherit
	ANY

	EL_IDENTIFIED_THREAD

	EL_PROGRESS_TRACKER

create
	make

feature {NONE} -- Initialization

	make (a_display: like display; a_action: like action)
		do
			display := a_display; action := a_action
			make_default
		end

feature -- Basic operations

	execute
			--
		do
			track_progress (display.new_file_progress_listener (0), action, agent do_nothing)
		end

feature {NONE} -- Internal attributes

	display: EL_PROGRESS_DISPLAY

	action: PROCEDURE

end
