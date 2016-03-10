note
	description: "[
		typedef struct _XRRScreenResources {
		    Time	timestamp;
		    Time	configTimestamp;
		    int		ncrtc;
		    RRCrtc	*crtcs;
		    int		noutput;
		    RROutput	*outputs;
		    int		nmode;
		    XRRModeInfo	*modes;
		} XRRScreenResources;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_X11_SCREEN_RESOURCES_CURRENT

inherit
	EL_C_OBJECT
		export
			{EL_X11_DISPLAY_OUTPUT_INFO} self_ptr
		redefine
			c_free
		end

	EL_X11_API
		export
			{NONE} all
		undefine
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			screen_number, root_window_number: INTEGER
		do
			display_ptr := open_default_display
			screen_number := X11_default_screen (display_ptr)
			root_window_number := X11_root_window (display_ptr, screen_number)
			make_from_pointer (XRR_get_screen_resources_current (display_ptr, root_window_number))

			create connected_output_info
			create output_info_list.make (output_count)
			(1 |..| output_count).do_all (
				agent (index: INTEGER)
					do
						output_info_list.extend (output_info (index))
						if output_info_list.last.is_active then
							connected_output_info := output_info_list.last
						end
					end
			)
		ensure
			connected_output_info_is_active: connected_output_info.is_active
		end

feature -- Access

	output_info_list: ARRAYED_LIST [EL_X11_DISPLAY_OUTPUT_INFO]

	connected_output_info: EL_X11_DISPLAY_OUTPUT_INFO

feature {EL_X11_DISPLAY_OUTPUT_INFO} -- Implementation

	open_default_display: POINTER
			--
		do
			Result := X11_open_display (Default_pointer)
		end

	output_count: INTEGER
		do
			Result := XRR_screen_resource_noutput (self_ptr)
		end

	output_info (index: INTEGER): EL_X11_DISPLAY_OUTPUT_INFO
		require
			valid_index: index >= 1 and index <= output_count
		local
			output_number: INTEGER
		do
			output_number := XRR_screen_resource_i_th_output (self_ptr, index - 1)
			create Result.make (Current, output_number)
		end

    c_free (self: POINTER)
            --
        local
        	status: INTEGER
        do
        	XRR_free_screen_resources (self)
        	if is_attached (display_ptr) then
        		status := X11_close_display (display_ptr)
        	end
        end

	display_ptr: POINTER

end
