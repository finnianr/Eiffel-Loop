note
	description: "[
		Thread for file serialization with progress notification
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-02 18:40:28 GMT (Saturday 2nd July 2016)"
	revision: "1"

class
	EL_FILE_PROCESS_THREAD

inherit
	EL_IDENTIFIED_THREAD

	EL_FILE_PROGRESS_TRACKER
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
			track_progress (display.new_progress_listener, action, agent do_nothing)
		end

feature {NONE} -- Internal attributes

	display: EL_FILE_PROGRESS_DISPLAY

	action: PROCEDURE [ANY, TUPLE]

end
