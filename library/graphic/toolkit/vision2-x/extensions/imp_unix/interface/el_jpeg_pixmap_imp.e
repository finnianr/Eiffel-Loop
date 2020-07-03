note
	description: "Unix implemenation of interface [$source EL_JPEG_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 13:37:56 GMT (Monday 29th June 2020)"
	revision: "2"

class
	EL_JPEG_PIXMAP_IMP

inherit
	EL_JPEG_PIXMAP_I

create
	make

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
		local
			handle, type, l_quality: EV_GTK_C_STRING
			gerror: POINTER
		do
			type := Type_jpeg; l_quality := quality.out
			create handle.make_from_path (file_path)
			{EL_GTK2}.gdk_pixbuf_save_jpeg (pixel_buffer, handle.item, type.item, l_quality.item, $gerror)
			if gerror /= default_pointer then
				on_fail (file_path.base)
			end
		end

feature {NONE} -- Disposal

	free_buffer
		do
			{GTK2}.object_unref (pixel_buffer)
		end

end
