note
	description: "[
		Thread for file serialization with progress notification
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 11:45:39 GMT (Saturday 6th March 2021)"
	revision: "8"

class
	EL_FILE_PROCESS_THREAD

inherit
	ANY

	EL_IDENTIFIED_THREAD

	EL_MODULE_TRACK

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
			Track.data_transfer (display, 0, action)
		end

feature {NONE} -- Internal attributes

	display: EL_PROGRESS_DISPLAY

	action: PROCEDURE

end