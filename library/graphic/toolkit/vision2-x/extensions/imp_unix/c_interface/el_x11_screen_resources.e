note
	description: "[
		Class based on C-struct
		
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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-13 10:47:18 GMT (Tuesday 13th October 2020)"
	revision: "7"

class
	EL_X11_SCREEN_RESOURCES

inherit
	EL_OWNED_C_OBJECT
		rename
			c_free as XRR_free_screen_resources
		export
			{EL_X11_DISPLAY_OUTPUT_INFO} self_ptr
		end

	EL_X11_EXTENSIONS_API

create
	make

feature {NONE} -- Initialization

	make (a_display: EL_X11_DISPLAY)
		do
			make_from_pointer (XRR_get_screen_resources_current (a_display.self_ptr, a_display.default_root_window))
			display := a_display
		end

feature -- Access

	active_output_info: detachable EL_X11_DISPLAY_OUTPUT_INFO
		local
			info: like new_output_info
		do
			across 1 |..| count as n until attached Result loop
				info := new_output_info (n.item)
				if info.is_active then
					Result := info
				end
			end
		end

	count: INTEGER
		do
			Result := XRR_screen_resource_noutput (self_ptr)
		end

	i_th_output (i: INTEGER): INTEGER
		do
			Result := XRR_screen_resource_i_th_output (self_ptr, i - 1)
		end

feature {EL_X11_DISPLAY_OUTPUT_INFO} -- Factory

	new_output_info (index: INTEGER): EL_X11_DISPLAY_OUTPUT_INFO
		require
			valid_index: 1 <= index and index <= count
		do
			create Result.make (XRR_get_output_info (display.self_ptr, self_ptr, i_th_output (index)))
		end

feature {NONE} -- Internal attributes

	display: EL_X11_DISPLAY
end