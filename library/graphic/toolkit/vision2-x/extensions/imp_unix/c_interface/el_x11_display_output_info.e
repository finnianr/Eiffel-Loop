note
	description: "[
		Class based on C-struct
			typedef struct _XRROutputInfo {
			    Time	    timestamp;
			    RRCrtc	    crtc;
			    char	    *name;
			    int		    nameLen;
			    unsigned long   mm_width;
			    unsigned long   mm_height;
			    Connection	    connection;
			    SubpixelOrder   subpixel_order;
			    int		    ncrtc;
			    RRCrtc	    *crtcs;
			    int		    nclone;
			    RROutput	    *clones;
			    int		    nmode;
			    int		    npreferred;
			    RRMode	    *modes;
			} XRROutputInfo;
			
		**Notes**
			static Display	*dpy;
			root = RootWindow (dpy, screen);
			res = XRRGetScreenResourcesCurrent (dpy, root);
	 	    for (o = 0; o < res->noutput; o++) {
				XRROutputInfo	*output_info = XRRGetOutputInfo (dpy, res, res->outputs[o]);
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 10:15:39 GMT (Saturday   26th   October   2019)"
	revision: "5"

class
	EL_X11_DISPLAY_OUTPUT_INFO

inherit
	EL_OWNED_C_OBJECT
		rename
			c_free as XRR_free_output_info
		end

	EL_X11_API

create
	make, default_create

feature {NONE} -- Initialization

	make (screen_resources: EL_X11_SCREEN_RESOURCES_CURRENT; output_number: INTEGER)
		do
			make_from_pointer (
				XRR_get_output_info (screen_resources.display_ptr, screen_resources.self_ptr, output_number)
			)
		end

feature -- Access

	connection: INTEGER
		do
			Result := XRR_output_info_connection (self_ptr)
		end

	crtc: POINTER
		do
			Result := XRR_output_info_crtc (self_ptr)
		end

	width_mm: INTEGER
		do
			if is_attached (self_ptr) then
				Result := XRR_output_info_mm_width (self_ptr)
			end
		end

	height_mm: INTEGER
		do
			Result := XRR_output_info_mm_height (self_ptr)
		end

feature -- Status query

	is_active: BOOLEAN
		do
			Result := connection = XRR_Connected and is_attached (crtc)
		end

end
