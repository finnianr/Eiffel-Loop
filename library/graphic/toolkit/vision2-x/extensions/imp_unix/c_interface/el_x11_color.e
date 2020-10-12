note
	description: "[
		X11 color structure
		
			typedef struct {
				unsigned long pixel;			/* pixel value */
				unsigned short red, green, blue;	/* rgb values */
				char flags;				/* DoRed, DoGreen, DoBlue */	
				char pad;
			} XColor;
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-12 14:46:11 GMT (Monday 12th October 2020)"
	revision: "1"

class
	EL_X11_COLOR

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			make_default as make
		export
			{EL_X11_IMAGE, EL_X11_DISPLAY} self_ptr
		end

create
	make

feature -- Access

	blue: NATURAL_16
		do
			Result := c_blue (self_ptr)
		end

	blue_proportion: REAL
		do
			Result := (blue / Sixteen_bits.Max_value).truncated_to_real
		end

	green: NATURAL_16
		do
			Result := c_green (self_ptr)
		end

	green_proportion: REAL
		do
			Result := (green / Sixteen_bits.Max_value).truncated_to_real
		end

	red: NATURAL_16
		do
			Result := c_red (self_ptr)
		end

	red_proportion: REAL
		do
			Result := (red / Sixteen_bits.Max_value).truncated_to_real
		end

feature -- Element change

	set_pixel (pixel: NATURAL)
		do
			c_set_pixel (self_ptr, pixel)
		end

feature {NONE} -- C Externals

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

	frozen c_size_of: INTEGER
		external
			"C [macro <X11/Xlib.h>]"
		alias
			"sizeof (XColor)"
		end

feature {NONE} -- Constants

	Sixteen_bits: NATURAL_16
end