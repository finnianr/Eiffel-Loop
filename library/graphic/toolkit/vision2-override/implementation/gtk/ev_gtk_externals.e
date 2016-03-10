note
	description: "Routines missing from class GTK"

	legal: "See notice at end of class."

	status: "See notice at end of class."

class
	EV_GTK_EXTERNALS

feature -- C Externals

	frozen set_gdk_event_button_struct_button (a_c_struct: POINTER; a_button: INTEGER)
		external
			"C [struct <gtk/gtk.h>] (GdkEventButton, guint)"
		alias
			"button"
		end

	frozen set_gdk_event_button_struct_state (a_c_struct: POINTER; a_state: INTEGER)
		external
			"C [struct <gtk/gtk.h>] (GdkEventButton, guint)"
		alias
			"state"
		end

	frozen c_g_timeval_struct_allocate: POINTER
		external
			"C inline use <gtk/gtk.h>"
		alias
			"calloc (sizeof(GTimeVal), 1)"
		end

	frozen g_get_current_time (a_result: POINTER)
		external
			"C (GTimeVal*) | <gtk/gtk.h>"
		end

	frozen g_timeval_struct_tv_sec (a_c_struct: POINTER): INTEGER
		external
			"C [struct <gtk/gtk.h>] (GTimeVal): EIF_INTEGER"
		alias
			"tv_sec"
		end

	frozen g_timeval_struct_tv_usec (a_c_struct: POINTER): INTEGER
		external
			"C [struct <gtk/gtk.h>] (GTimeVal): EIF_INTEGER"
		alias
			"tv_usec"
		end

	frozen set_gdk_event_button_struct_time (a_c_struct: POINTER; a_time: INTEGER)
		external
			"C [struct <gtk/gtk.h>] (GdkEventButton, guint32)"
		alias
			"time"
		end

	frozen gdk_event_put (a_event: POINTER)
		external
			"C (GdkEvent*) | <gtk/gtk.h>"
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end
