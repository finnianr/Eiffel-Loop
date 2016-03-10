note
	description: "[
		Thread for file serialization with progress notification
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-22 16:21:33 GMT (Monday 22nd December 2014)"
	revision: "3"

class
	EL_FILE_PROCESS_THREAD

inherit
	EL_IDENTIFIED_THREAD
		redefine
			is_visible_in_console
		end

	EL_SHARED_FILE_PROGRESS_LISTENER
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_listener: like listener; a_action: like action)
		do
			listener := a_listener; action := a_action
			default_create
		end

feature -- Basic operations

	execute
			--
		do
			track_progress (listener, action, agent do_nothing)
		end

feature {NONE} -- Implementation

	listener: EL_FILE_PROGRESS_LISTENER

	action: PROCEDURE [ANY, TUPLE]

	is_visible_in_console: BOOLEAN = True

end
