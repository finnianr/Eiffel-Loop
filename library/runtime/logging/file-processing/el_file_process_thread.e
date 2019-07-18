note
	description: "[
		Thread for file serialization with progress notification
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 12:47:25 GMT (Monday 1st July 2019)"
	revision: "5"

class
	EL_FILE_PROCESS_THREAD

inherit
	EL_IDENTIFIED_THREAD

	EL_PROGRESS_TRACKER
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_display: like display; a_action: like action)
		do
			display := a_display; action := a_action
			default_create
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
