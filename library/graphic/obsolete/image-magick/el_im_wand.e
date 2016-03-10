note
	description: "Summary description for {EL_MAGICK_IMAGE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_IM_WAND

inherit
	EL_C_OBJECT
		redefine
			c_free, is_memory_owned
		end

	EL_IM_API

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
		do
			make_from_pointer (c_new_magick_wand)
		end

feature -- Status query

	has_error: BOOLEAN

    is_memory_owned: BOOLEAN = TRUE

feature -- Element change

	set_image (a_file_path: EL_FILE_PATH)
		do
			set_error (c_magick_read_image (self_ptr, a_file_path.string.area.base_address))
		end

	set_error (flag: BOOLEAN)
		do
			has_error := flag
		end

feature -- Status change

	set_image_format (a_format: STRING)
		do
			set_error (c_magick_set_image_format (self_ptr, a_format.area.base_address))
		end

	set_image_width (a_width: INTEGER)
		do
			transform_image (Default_geometry, a_width.out)
		end

	set_image_background_color_24_bit (a_rgb_24_bit: INTEGER)
		local
			existing_color, background: EL_IM_PIXEL_WAND
		do
			create existing_color.make
			create background.make
			existing_color.set_color ("white")
			background.set_color_24_bit (a_rgb_24_bit)
			set_error (
				c_magick_flood_fill_paint_image (self_ptr, c_all_channels, background.self_ptr, 50, existing_color.self_ptr, 0, 0, False)
			)
			existing_color.close; background.close
		end

	set_image_transparency_color_24_bit (a_rgb_24_bit: INTEGER)
		local
			pixel_wand: EL_IM_PIXEL_WAND
		do
			create pixel_wand.make
			pixel_wand.set_color_24_bit (a_rgb_24_bit)
			set_error (c_magick_transparent_paint_image (self_ptr, pixel_wand.self_ptr, 0, 20, False))
			pixel_wand.close
		end

feature -- Basic operations

	write_image (a_file_path: EL_FILE_PATH)
		do
			set_error (c_magick_write_image (self_ptr, a_file_path.string.area.base_address))
		end

	close
		do
        	if is_attached (self_ptr) then
	        	c_clear_magick_wand (self_ptr)
	        	self_ptr := c_destroy_magick_wand (self_ptr)
        	end
		end

feature {NONE} -- Implementation

	transform_image (crop_geometry, size_geometry: STRING)
		local
			new_wand_ptr: POINTER
		do
			new_wand_ptr := c_magick_transform_image (self_ptr, crop_geometry.area.base_address, size_geometry.area.base_address)
			if is_attached (new_wand_ptr) then
				close
				make_from_pointer (new_wand_ptr)
			end
		end

	flatten_image_layers
		local
			new_wand_ptr: POINTER
		do
			new_wand_ptr := c_magick_flatten_image_layers (self_ptr)
			if is_attached (new_wand_ptr) then
				close
				make_from_pointer (new_wand_ptr)
			end
		end

feature {NONE} -- Disposal

    c_free (this: POINTER)
            --
        do
        	close
        end

feature {NONE} -- Constants

	Default_geometry: STRING
		once
			Result := "0x0"
		end

end
