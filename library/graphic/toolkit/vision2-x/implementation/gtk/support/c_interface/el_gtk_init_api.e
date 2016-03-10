note
	description: "Summary description for {EL_GTK_INIT_API}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GTK_INIT_API

feature {NONE} -- C externals	

	frozen c_gtk_get_useable_screen_area (rectangle: POINTER)
			-- void gtk_get_useable_screen_area (gint *rectangle);
		external
			"C (gint*) | <gtk-init.h>"
		alias
			"gtk_get_useable_screen_area"
		end
end
