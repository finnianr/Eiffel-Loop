note
	description: "Summary description for {EL_PIXEL_WAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_IM_PIXEL_WAND

inherit
	EL_C_OBJECT
		export
			{EL_IM_WAND} self_ptr
		redefine
			c_free, is_memory_owned
		end

	EL_IM_API

create
	make

feature {NONE} -- Initialization

	make
		do
			make_from_pointer (c_new_pixel_wand)
		end

feature -- Status query

	has_error: BOOLEAN

    is_memory_owned: BOOLEAN = TRUE

feature -- Element change

	set_error (flag: BOOLEAN)
		do
			has_error := flag
		end

feature -- Status change

	set_color_24_bit (a_rgb_24_bit: INTEGER)
		local
			color_spec: STRING
		do
			create color_spec.make_from_string ("#")
			color_spec.append (a_rgb_24_bit.to_hex_string.substring (3, 8))
			set_color (color_spec)
		end

	set_color (color_spec: STRING)
		do
			set_error (c_pixel_set_color (self_ptr, color_spec.area.base_address))
		end

	close
		do
        	if is_attached (self_ptr) then
	        	self_ptr := c_destroy_pixel_wand (self_ptr)
        	end
		end

feature {NONE} -- Disposal

    c_free (this: POINTER)
            --
        do
        	close
        end

end
