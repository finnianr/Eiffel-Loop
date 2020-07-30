note
	description: "Unix implemenation of interface [$source EL_JPEG_IMAGE_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-14 23:02:48 GMT (Tuesday 14th July 2020)"
	revision: "4"

class
	EL_JPEG_IMAGE_IMP

inherit
	EL_JPEG_IMAGE_I

create
	make

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
		require else
			valid_gtk_version: {GTK}.gtk_maj_ver >= 2
		local
			handle, type: EV_GTK_C_STRING
			gerror, pixel_buffer: POINTER
		do
			pixel_buffer := new_pixel_buffer
			if is_attached (pixel_buffer) then
				type := Type_jpeg
				create handle.make_from_path (file_path)
				{EL_GTK2}.gdk_pixbuf_save_jpeg (pixel_buffer, handle.item, type.item, quality_parameter.item, $gerror)
				{GTK2}.object_unref (pixel_buffer)
				if gerror /= default_pointer then
					on_fail (file_path.base)
				end
			else
				on_fail (file_path.base)
			end
		end

feature {NONE} -- Implementation

	quality_parameter: EV_GTK_C_STRING
		do
			Result := quality.out
		end

	new_pixel_buffer: POINTER
		do
			if attached {EL_DRAWABLE_PIXEL_BUFFER_IMP} pixel_component as buffer then
				Result := buffer.gdk_pixbuf

			elseif attached {EL_PIXMAP_IMP} pixel_component as pixmap then
				Result := pixmap.pixbuf_from_drawable
			end
		end

end
