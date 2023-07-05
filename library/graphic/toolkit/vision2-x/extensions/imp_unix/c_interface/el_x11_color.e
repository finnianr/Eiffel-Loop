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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-03 16:14:32 GMT (Monday 3rd July 2023)"
	revision: "4"

class
	EL_X11_COLOR

inherit
	EL_ALLOCATED_C_OBJECT
		rename
			c_size_of as c_size_of_XColor,
			make_default as make
		end

	EL_X11_API
		undefine
			copy, is_equal
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
			Result := (blue / Max_value).truncated_to_real
		end

	green: NATURAL_16
		do
			Result := c_green (self_ptr)
		end

	green_proportion: REAL
		do
			Result := (green / Max_value).truncated_to_real
		end

	red: NATURAL_16
		do
			Result := c_red (self_ptr)
		end

	red_proportion: REAL
		do
			Result := (red / Max_value).truncated_to_real
		end

feature -- Element change

	set_pixel (pixel: NATURAL)
		do
			c_set_pixel (self_ptr, pixel)
		end

feature {NONE} -- Constants

	Max_value: NATURAL_16
		once
			Result := Result.Max_value
		end
end