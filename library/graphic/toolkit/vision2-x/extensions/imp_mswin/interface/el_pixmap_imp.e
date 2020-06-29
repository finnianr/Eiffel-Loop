note
	description: "Unix implemenation of interface [$source EL_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 10:11:50 GMT (Monday 29th June 2020)"
	revision: "1"

class
	EL_PIXMAP_IMP

inherit
	EV_PIXMAP_IMP
		redefine
			interface
		end

	EL_PIXMAP_I
		undefine
			flush,
			save_to_named_path
		redefine
			interface
		end

create
	make

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; a_quality: INTEGER)
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

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_PIXMAP note option: stable attribute end;

feature {NONE} -- Constants

	Type_jpeg: STRING = "jpeg"

end
