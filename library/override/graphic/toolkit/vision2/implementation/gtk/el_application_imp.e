note
	description: "[
		Mechanism to queue events from external threads and process them in the main GUI thread
		by putting a dummy button event into the GTK message queue. The button state (normally used to store
		a set of flags) is used to store an index which maps the event to an agent. 
		Procedure 'on_event' calls the agent associated with the index.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_APPLICATION_IMP

inherit
	EV_APPLICATION_IMP
		redefine
			process_button_event, make
		end

	EL_APPLICATION_I
		undefine
			dispose, make, focused_widget, call_post_launch_actions
		end

	EL_EVENT_EMITTER
		rename
			make as make_emitter
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

feature --Access

	event_emitter: EL_EVENT_EMITTER
		do
			Result := Current
		end

feature -- Basic operations

	generate (index: INTEGER)
			--
		local
			l_event, l_timeval: POINTER
			l_time_millisecs, l_time_secs, l_time_micro_secs: INTEGER
		do
			l_event := gdk_event_new ({GTK}.gdk_button_press_enum)
			{EV_GTK_EXTERNALS}.set_gdk_event_button_struct_button (l_event, Button_code_extra)
			{EV_GTK_EXTERNALS}.set_gdk_event_button_struct_state (l_event, index)

			-- Set time
			l_timeval := {EV_GTK_EXTERNALS}.c_g_timeval_struct_allocate
			{EV_GTK_EXTERNALS}.g_get_current_time (l_timeval)
			l_time_secs := {EV_GTK_EXTERNALS}.g_timeval_struct_tv_sec (l_timeval)
			l_time_micro_secs  := {EV_GTK_EXTERNALS}.g_timeval_struct_tv_usec (l_timeval)
			{GTK}.g_free (l_timeval)

			l_time_millisecs := l_time_secs * 1000 + l_time_micro_secs // 1000
			{EV_GTK_EXTERNALS}.set_gdk_event_button_struct_time (l_event, l_time_millisecs)

--			Didn't work for whatever reason
--			l_sent_event_status := {GTK}.gdk_event_any_struct_send_event (l_event)

			{EV_GTK_EXTERNALS}.gdk_event_put (l_event)
		end

feature {EV_WINDOW_IMP} -- Implementation

	process_button_event (a_gdk_button_event: POINTER)
			-- Process button event `a_gdk_event'.
		local
			l_button: INTEGER
		do
			l_button := {GTK}.gdk_event_button_struct_button (a_gdk_button_event)
			if l_button = Button_code_extra then
				listener.on_event ({GTK}.gdk_event_button_struct_state (a_gdk_button_event).to_integer_32)
			else
				Precursor (a_gdk_button_event)
			end
		end

feature {NONE} -- Constants

	Button_code_extra: INTEGER = 16

feature {NONE} -- C externals

	frozen gdk_event_new (a_type: INTEGER): POINTER
		external
			"C (GdkEventType): GdkEvent* | <gtk/gtk.h>"
		end

end
