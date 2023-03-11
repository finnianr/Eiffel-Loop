note
	description: "Functions from `X11/extensions/Xrandr.h'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_X11_EXTENSIONS_API

inherit
	EL_C_API_ROUTINES

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

end
