note
	description: "Provides access to unexported image data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_IMAGE_ACCESS_IMP

inherit
	EV_POINTER_STYLE_IMP
		export
			{NONE} all
		end

	EL_C_API_ROUTINES

create
	make

feature {EL_SHARED_IMAGE_ACCESS} -- Access

	data (pixels: EV_ANY_I): POINTER
		require
			valid_pixels: attached {EV_PIXMAP_IMP} pixels or attached {EV_PIXEL_BUFFER_IMP} pixels
		-- Pointer to the GdkPixmap image data.
		do
			if attached {EV_PIXMAP_IMP} pixels as pixmap then
				Result := pixmap.drawable
			elseif attached {EV_PIXEL_BUFFER_IMP} pixels as buffer then
				Result := buffer.gdk_pixbuf
			end
		ensure
			not_null: is_attached (Result)
		end
end