note
	description: "Summary description for {EL_PANGO_CAIRO_CONTEXT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PANGO_CAIRO_CONTEXT

inherit
	EL_OWNED_C_OBJECT
		export
			{EL_DRAWABLE_PIXEL_BUFFER_I} self_ptr
		end

	EL_SHARED_CAIRO_API

	EL_SHARED_GOBJECT_API

	EL_SHARED_PANGO_CAIRO_API

	EL_CAIRO_CONSTANTS

feature {NONE} -- Initialization

	make_with_size (pixel_data: POINTER; format, width, height: INTEGER)
		require
			valid_format: format = Cairo_format_ARGB_32 or format = Cairo_format_RGB_24
		local
			stride: INTEGER
		do
			stride := Cairo.format_stride_for_width (format, width)
			surface := Cairo.new_image_surface_for_data (pixel_data, format, width, height, stride)
			make_from_pointer (Cairo.new_cairo (surface))
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
			--
		do
			if is_attached (internal_pango_layout) then
				Gobject.object_unref (internal_pango_layout)
			end
			Cairo.destroy (self_ptr); Cairo.destroy_surface (surface)
		end

	pango_layout: POINTER
		do
			Result := internal_pango_layout
			if not is_attached (Result) then
				Result := Pango_cairo.create_layout (self_ptr)
				internal_pango_layout := Result
			end
		end

feature {EL_DRAWABLE_PIXEL_BUFFER_I} -- Internal attributes

	surface: POINTER

	internal_pango_layout: POINTER

end
