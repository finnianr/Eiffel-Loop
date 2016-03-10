note
	description: "Summary description for {EL_X11_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_X11_API

inherit
	EL_MEMORY

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

feature {NONE} -- C Externals: Xrandr.h

	frozen XRR_get_screen_resources_current (display_ptr: POINTER; window_number: INTEGER): POINTER
			-- XRRScreenResources *XRRGetScreenResourcesCurrent (Display *dpy, Window window);
		require
			arg_attached: is_attached (display_ptr)
		external
			"C (Display*, Window): EIF_POINTER | <X11/extensions/Xrandr.h>"
		alias
			"XRRGetScreenResourcesCurrent"
		end

	frozen XRR_free_screen_resources (resources_ptr: POINTER)
			-- void XRRFreeScreenResources (XRRScreenResources *resources);
		require
			arg_attached: is_attached (resources_ptr)
		external
			"C (XRRScreenResources*) | <X11/extensions/Xrandr.h>"
		alias
			"XRRFreeScreenResources"
		end

	frozen XRR_get_output_info (display_ptr, resources_ptr: POINTER; output_number: INTEGER): POINTER
			-- XRROutputInfo *XRRGetOutputInfo (Display *dpy, XRRScreenResources *resources, RROutput output);
		require
			arg_attached: is_attached (display_ptr) and is_attached (resources_ptr)
		external
			"C (Display*, XRRScreenResources*, RROutput): EIF_POINTER | <X11/extensions/Xrandr.h>"
		alias
			"XRRGetOutputInfo"
		end

    frozen XRR_output_info_connection (output_info_ptr: POINTER): INTEGER
            --
		require
			arg_attached: is_attached (output_info_ptr)
        external
            "C [struct <X11/extensions/Xrandr.h>] (XRROutputInfo): EIF_INTEGER"
        alias
            "connection"
        end

    frozen XRR_output_info_mm_width (output_info_ptr: POINTER): INTEGER
            --
		require
			arg_attached: is_attached (output_info_ptr)
        external
            "C [struct <X11/extensions/Xrandr.h>] (XRROutputInfo): EIF_INTEGER"
        alias
            "mm_width"
        end

    frozen XRR_output_info_mm_height (output_info_ptr: POINTER): INTEGER
            --
		require
			arg_attached: is_attached (output_info_ptr)
        external
            "C [struct <X11/extensions/Xrandr.h>] (XRROutputInfo): EIF_INTEGER"
        alias
            "mm_height"
        end

    frozen XRR_output_info_crtc (output_info_ptr: POINTER): POINTER
            --
		require
			arg_attached: is_attached (output_info_ptr)
        external
            "C [struct <X11/extensions/Xrandr.h>] (XRROutputInfo): EIF_INTEGER"
        alias
            "crtc"
        end

	frozen XRR_free_output_info (output_info_ptr: POINTER)
			-- void XRRFreeOutputInfo (XRROutputInfo *outputInfo);
		require
			arg_attached: is_attached (output_info_ptr)
		external
			"C (XRROutputInfo*) | <X11/extensions/Xrandr.h>"
		alias
			"XRRFreeOutputInfo"
		end

    frozen XRR_screen_resource_noutput (resource_ptr: POINTER): INTEGER
            --
		require
			arg_attached: is_attached (resource_ptr)
        external
            "C [struct <X11/extensions/Xrandr.h>] (XRRScreenResources): EIF_INTEGER"
        alias
            "noutput"
        end

	frozen XRR_screen_resource_i_th_output (resource_ptr: POINTER; index: INTEGER): INTEGER
		require
			arg_attached: is_attached (resource_ptr)
			valid_index: index < XRR_screen_resource_noutput (resource_ptr)
		external
			"C inline use <X11/extensions/Xrandr.h>"
		alias
			"((XRRScreenResources*) $resource_ptr)->outputs [$index]"
		end

feature {NONE}-- Constants

	frozen XRR_Connected: INTEGER
		external
			"C [macro <X11/extensions/Xrandr.h>]: EIF_INTEGER"
		alias
			"RR_Connected"
		end

end
