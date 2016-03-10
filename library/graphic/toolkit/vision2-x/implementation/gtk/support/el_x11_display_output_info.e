note
	description: "[
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
	]"

	notes: "[

		static Display	*dpy;
		root = RootWindow (dpy, screen);
		res = XRRGetScreenResourcesCurrent (dpy, root);
 	    for (o = 0; o < res->noutput; o++) {
			XRROutputInfo	*output_info = XRRGetOutputInfo (dpy, res, res->outputs[o]);
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_X11_DISPLAY_OUTPUT_INFO

inherit
	EL_C_OBJECT
		redefine
			c_free
		end

	EL_X11_API
		undefine
			dispose
		end
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
			if is_attached (self_ptr) then
				Result := XRR_output_info_connection (self_ptr)
			end
		end

	crtc: POINTER
		do
			if is_attached (self_ptr) then
				Result := XRR_output_info_crtc (self_ptr)
			end
		end

	width_mm: INTEGER
		do
			if is_attached (self_ptr) then
				Result := XRR_output_info_mm_width (self_ptr)
			end
		end

	height_mm: INTEGER
		do
			if is_attached (self_ptr) then
				Result := XRR_output_info_mm_height (self_ptr)
			end
		end

feature -- Status query

	is_active: BOOLEAN
		do
			if is_attached (self_ptr) then
				Result := connection = XRR_Connected and is_attached (crtc)
			end
		end
feature {NONE} -- Implementation

    c_free (self: POINTER)
            --
        do
        	if is_attached (self) then
	        	XRR_free_output_info (self)
        	end
        end
end
