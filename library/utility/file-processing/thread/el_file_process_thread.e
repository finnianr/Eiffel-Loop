note
	description: "[
		Thread for file serialization with progress notification
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-13 17:54:09 GMT (Wednesday 13th March 2013)"
	revision: "2"

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
			File_listener.put (listener)
			action.apply
			listener.finish
			File_listener.put (Do_nothing_listener)
		end

feature {NONE} -- Implementation

	listener: EL_FILE_PROGRESS_LISTENER

	action: PROCEDURE [ANY, TUPLE]

	is_visible_in_console: BOOLEAN = True

end
