note
	description: "Windows implementation of `to_jpeg'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-03 13:02:44 GMT (Friday 3rd July 2020)"
	revision: "2"

class
	EL_PIXMAP_TO_JPEG_IMP

feature -- Conversion

	to_jpeg (quality: INTEGER): EL_JPEG_PIXMAP_I
		local
			gerror, gdk_pixbuf: POINTER
--			handle, type, quality: EV_GTK_C_STRING
		do
--			gdk_pixbuf := pixbuf_from_drawable
--			create handle.make_from_path (file_path)
--			type := Type_jpeg; quality := a_quality.out
--			{EL_GTK2}.gdk_pixbuf_save_jpeg (gdk_pixbuf, handle.item, type.item, quality.item, $gerror)
			if gerror /= default_pointer then
				-- We could not save the image so raise an exception
				(create {EXCEPTIONS}).raise ("Could not save image file.")
			end
--			{GTK2}.object_unref (gdk_pixbuf)
		end

end
