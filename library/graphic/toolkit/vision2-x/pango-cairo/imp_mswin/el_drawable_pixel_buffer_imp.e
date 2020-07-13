note
	description: "Windows implementation of [$source EL_DRAWABLE_PIXEL_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 17:34:41 GMT (Monday 13th July 2020)"
	revision: "12"

class
	EL_DRAWABLE_PIXEL_BUFFER_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			data_ptr as pixel_data,
			draw_text as buffer_draw_text,
			draw_pixel_buffer as draw_pixel_buffer_at_rectangle,
			lock as lock_rgb_24,
			unlock as unlock_rgb_24,
			make_with_pixmap as make_rgb_24_with_pixmap,
			make_with_size as make_rgb_24_with_size,
			set_with_named_path as set_rgb_24_with_path,
			height as buffer_height,
			width as buffer_width
		undefine
			default_create
		redefine
			interface, old_make
		end

	EL_DRAWABLE_PIXEL_BUFFER_I
		undefine
			unlock_rgb_24
		redefine
			interface
		end

	EL_MODULE_SYSTEM_FONTS

	WEL_GDIP_IMAGE_ENCODER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	old_make (an_interface: EL_DRAWABLE_PIXEL_BUFFER)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		local
			list: WEL_GDIP_IMAGE_ENCODER_PARAMETERS
		do
			if Is_gdi_plus_installed and then attached gdip_bitmap as l_bitmap then
				create list.make (1)
				list.parameters.extend (create {WEL_GDIP_IMAGE_ENCODER_PARAMETER}.make (Jpeg_encoder.Quality, quality))
				l_bitmap.save_image_to_path_with_encoder_and_parameters (file_path, Jpeg, list)
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	adjust_color_channels
		do
		end

feature {NONE} -- Constants

	Jpeg_encoder: WEL_GDIP_IMAGE_ENCODER
		local
			guid: WEL_GUID
		once
			create guid.make_empty
			create Result.make (guid)
			Result := Result.jpg
		end
end
