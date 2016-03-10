note
	description: "[
		Mechanism to queue events from external threads and process them in the main GUI thread
		by putting a dummy button event into the GTK message queue. The button state (normally used to store
		a set of flags) is used to store an index which maps the event to an agent. 
		Procedure 'on_event' calls the agent associated with the index.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-26 17:25:35 GMT (Tuesday 26th February 2013)"
	revision: "2"

class
	EL_APPLICATION_IMP

inherit
	EV_APPLICATION_IMP
		rename
			Silly_main_window as Event_emitting_main_window
		redefine
			make, Event_emitting_main_window
		end

	EL_APPLICATION_I
		rename
			event_emitter as Event_emitting_main_window
		undefine
			dispose, make, focused_widget, call_post_launch_actions, wake_up_gui_thread
		end

	EL_EVENT_EMITTER
		rename
			make as make_emitter
		redefine
			set_listener
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EV_APPLICATION_IMP}
			make_emitter
		end

feature -- Element change

	set_listener (a_listener: like listener)
		do
			Precursor (listener)
			Event_emitting_main_window.set_listener (a_listener)
		end

feature -- Basic operations

	generate (index: INTEGER)
		do
			Event_emitting_main_window.generate (index)
		end

feature -- Root window

	Event_emitting_main_window: EL_INTERNAL_EVENT_EMITTER_WINDOW_IMP
			-- Found a new use for silly window
		once
			create Result.make_top ("Main Window")
			Result.move (0, 0)
		end

end
