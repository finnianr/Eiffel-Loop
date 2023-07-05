note
	description: "Functions from `X11/Xlib.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-03 16:10:00 GMT (Monday 3rd July 2023)"
	revision: "9"

class
	EL_X11_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- C Externals

	frozen X11_open_display (display_name: POINTER): POINTER
			-- extern Display *XOpenDisplay(
			--     _Xconst char*	/* display_name */
			-- );
		external
			"C (_Xconst char*): EIF_POINTER  | <X11/Xlib.h>"
		alias
			"XOpenDisplay"
		end

	frozen X11_close_display (display_ptr: POINTER): INTEGER
			-- extern void *XCloseDisplay(
			--     Display*	/* display */
			-- );
		require
			arg_attached: is_attached (display_ptr)
		external
			"C (Display*): EIF_INTEGER | <X11/Xlib.h>"
		alias
			"XCloseDisplay"
		end

	frozen X11_default_screen (display_ptr: POINTER): INTEGER
			-- extern int XDefaultScreen(
			--     Display*		/* display */
			-- );
		require
			arg_attached: is_attached (display_ptr)
		external
			"C (Display*): EIF_INTEGER | <X11/Xlib.h>"
		alias
			"XDefaultScreen"
		end

	frozen X11_free (ptr: POINTER)
			-- XFree(data) void *data;
		require
			arg_attached: is_attached (ptr)
		external
			"C (void*) | <X11/Xlib.h>"
		alias
			"XFree"
		end

	frozen X11_get_image (display: POINTER; window, x, y: INTEGER; height, width: NATURAL): POINTER
			-- XGetImage (d, RootWindow (d, DefaultScreen (d)), x, y, 1, 1, AllPlanes, XYPixmap);

			-- XImage *XGetImage(display, d, x, y, width, height, plane_mask, format)
			-- Display *display;
			-- Drawable d;
			-- int x, y;
			-- unsigned int width, height;
			-- unsigned long plane_mask;
			-- int format;
		external
			"C inline use <X11/Xlib.h>"
		alias
			"return XGetImage ((Display *)$display, (Drawable)$window, $x, $y, $width, $height, AllPlanes, XYPixmap);"
		end

	frozen X11_get_image_pixel (image: POINTER; x, y: INTEGER): NATURAL
			-- unsigned long XGetPixel (XImage *ximage; int x; int y)
		require
			arg_attached: is_attached (image)
		external
			"C (XImage*, int, int): EIF_NATURAL | <X11/Xlib.h>"
		alias
			"XGetPixel"
		end

	frozen X11_query_color_rgb (display, color: POINTER; screen: INTEGER)
			-- XQueryColor(Display *display; Colormap colormap; XColor *def_in_out;
		external
			"C inline use <X11/Xlib.h>"
		alias
			"XQueryColor ((Display *)$display, DefaultColormap((Display *)$display, $screen), (XColor *)$color)"
		end

	frozen X11_root_window (display_ptr: POINTER; screen_number: INTEGER): INTEGER
			-- extern Window XRootWindow(
			--     Display*		/* display */,
			--     int			/* screen_number */
			-- );
		require
			arg_attached: is_attached (display_ptr)
		external
			"C (Display*, int): EIF_INTEGER | <X11/Xlib.h>"
		alias
			"XRootWindow"
		end

feature {NONE} -- XColor

	frozen c_blue (this: POINTER): NATURAL_16
		external
			"C [struct <X11/Xlib.h>] (XColor): EIF_NATURAL_16"
		alias
			"blue"
		end

	frozen c_green (this: POINTER): NATURAL_16
		external
			"C [struct <X11/Xlib.h>] (XColor): EIF_NATURAL_16"
		alias
			"green"
		end

	frozen c_red (this: POINTER): NATURAL_16
		external
			"C [struct <X11/Xlib.h>] (XColor): EIF_NATURAL_16"
		alias
			"red"
		end

	frozen c_set_pixel (this: POINTER; pixel: NATURAL)
		external
			"C [struct <X11/Xlib.h>] (XColor, unsigned long)"
		alias
			"pixel"
		end

	frozen c_size_of_XColor: INTEGER
		external
			"C [macro <X11/Xlib.h>]"
		alias
			"sizeof (XColor)"
		end

end