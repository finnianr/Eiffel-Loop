note
	description: "JPEG file interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 12:15:33 GMT (Saturday 1st August 2020)"
	revision: "7"

class
	EL_JPEG_IMAGE

inherit
	EV_ANY_HANDLER

	EL_MODULE_EXCEPTION

	EL_POINTER_ROUTINES

create
	make

feature {NONE} -- Initialization

	make (component: EV_ANY; a_quality: NATURAL)
		require
			valid_type: attached {EV_PIXMAP} component or attached {EL_PIXEL_BUFFER} component
			percentage: 0 <= a_quality and a_quality <= 100
		do
			pixel_component := component; quality := a_quality
		end

feature -- Access

	quality: NATURAL

feature -- Basic operations

	save_as (file_path: EL_FILE_PATH)
		local
			surface: detachable CAIRO_PIXEL_SURFACE_I
		do
			if attached {EL_PIXEL_BUFFER} pixel_component as buffer then
				surface := buffer.to_surface
			elseif attached {EV_PIXMAP} pixel_component as pixmap then
				create {CAIRO_PIXEL_SURFACE_IMP} surface.make_with_pixmap (pixmap)
			end
			if attached surface as s then
				s.save_as_jpeg (file_path, quality)
				s.destroy
			end
		end

feature {NONE} -- Event handling

	on_fail (base: ZSTRING)
		do
			Exception.raise_developer ("Could not save file %"%S%" as jpeg", [base])
		end

feature {NONE} -- Internal attributes

	pixel_component: EV_ANY

feature {NONE} -- Constants

	Type_jpeg: STRING = "jpeg"

end
