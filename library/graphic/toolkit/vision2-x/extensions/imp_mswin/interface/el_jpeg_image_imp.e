note
	description: "Windows implemenation of interface [$source EL_JPEG_IMAGE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-14 14:50:44 GMT (Tuesday 14th July 2020)"
	revision: "3"

class
	EL_JPEG_IMAGE_IMP

inherit
	EL_JPEG_IMAGE_I
		redefine
			make
		end

	WEL_GDIP_IMAGE_ENCODER_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (component: EV_ANY_I; a_quality: NATURAL)
		local
			buffer: EL_DRAWABLE_PIXEL_BUFFER
		do
			Precursor (component, a_quality)
			if attached {EL_PIXMAP_IMP} component as pixmap then
				create buffer.make_with_pixmap (24, pixmap.interface)
				pixel_component := buffer.implementation
			end
		end

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
		local
			list: WEL_GDIP_IMAGE_ENCODER_PARAMETERS
		do
			if attached gdip_bitmap as l_bitmap then
				create list.make (1)
				list.parameters.extend (quality_parameter)
				l_bitmap.save_image_to_path_with_encoder_and_parameters (file_path, Jpeg, list)
			end
		end

feature {NONE} -- Implementation

	gdip_bitmap: detachable WEL_GDIP_BITMAP
		do
			if attached {EV_PIXEL_BUFFER_IMP} pixel_component as buffer and then buffer.Is_gdi_plus_installed then
				Result := buffer.gdip_bitmap
			end
		end

	quality_parameter: WEL_GDIP_IMAGE_ENCODER_PARAMETER
		do
			create Result.make (Jpeg.Quality, quality)
		end
end
