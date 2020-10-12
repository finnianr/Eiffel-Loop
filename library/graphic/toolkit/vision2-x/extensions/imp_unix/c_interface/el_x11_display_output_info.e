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
	]"
	notes: "[
		**C code**
		
			static Display	*dpy;
			root = RootWindow (dpy, screen);
			res = XRRGetScreenResourcesCurrent (dpy, root);
			for (o = 0; o < res->noutput; o++) {
				XRROutputInfo	*output_info = XRRGetOutputInfo (dpy, res, res->outputs[o]);
			}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-12 12:17:10 GMT (Monday 12th October 2020)"
	revision: "6"

class
	EL_X11_DISPLAY_OUTPUT_INFO

inherit
	EL_OWNED_C_OBJECT
		rename
			c_free as XRR_free_output_info,
			make_from_pointer as make
		end

	EL_X11_EXTENSIONS_API

create
	make, default_create

feature -- Access

	connection: INTEGER
		do
			Result := XRR_output_info_connection (self_ptr)
		end

	output_info: POINTER
		do
			Result := XRR_output_info_crtc (self_ptr)
		end

	width_mm: INTEGER
		do
			if is_attached (self_ptr) then
				Result := XRR_output_info_mm_width (self_ptr)
			else
				Result := 297
			end
		end

	height_mm: INTEGER
		do
			if is_attached (self_ptr) then
				Result := XRR_output_info_mm_height (self_ptr)
			else
				Result := 210
			end
		end

feature -- Status query

	is_active: BOOLEAN
		do
			Result := connection = XRR_Connected and is_attached (output_info)
		end

end