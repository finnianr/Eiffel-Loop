note
	description: "Windows implemenation of interface [$source EL_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_PIXMAP_IMP

inherit
	EV_PIXMAP_IMP
		redefine
			effective_load_file, interface, promote_to_drawable, promote_to_widget
		end

	EL_PIXMAP_I
		undefine
			flush,
			save_to_named_path,
			on_parented,
			set_pebble,
			set_actual_drop_target_agent,
			set_pebble_function,
			draw_straight_line,
			disable_initialized
		redefine
			interface
		end

	EL_MODULE_GDI_BITMAP

create
	make

feature {NONE} -- Initialization

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		local
			src_bitmap, dest_bitmap: WEL_GDIP_BITMAP
		do
			src_bitmap := Gdi_bitmap.new (other)
			dest_bitmap := Gdi_bitmap.new_scaled (dimension, src_bitmap, size)

			set_bitmap_and_mask (dest_bitmap.new_bitmap, Void, dest_bitmap.width, dest_bitmap.height)

			dest_bitmap.destroy_item; src_bitmap.destroy_item

			set_is_initialized (True)
		end

	init_from_buffer (drawing: CAIRO_DRAWING_AREA)
			-- Initialize from `pixel_buffer'
		local
			l_bitmap: WEL_GDIP_BITMAP
		do
			if attached {CAIRO_DRAWING_AREA_IMP} drawing.implementation as drawing_imp then
				if attached private_bitmap as private then
					private.delete
				end
				if attached private_mask_bitmap as private then
					private.delete
				end
				l_bitmap := drawing_imp.to_gdi_bitmap
				set_bitmap_and_mask (l_bitmap.new_bitmap, Void, drawing_imp.width, drawing_imp.height)
				l_bitmap.destroy_item
			end
		end

feature {NONE} -- Implementation

	promote_to_drawable
			-- Promote the current implementation to
			-- EL_PIXMAP_IMP_DRAWABLE which allows
			-- drawing operations on the pixmap.
		local
			drawable_pixmap: EL_PIXMAP_IMP_DRAWABLE
		do
				-- Discard current implementation
			if not is_destroyed then
				create drawable_pixmap.make_with_simple (Current)
				attached_interface.replace_implementation (drawable_pixmap)
				safe_destroy
			end
		end

	promote_to_widget
			-- Promote the current implementation to
			-- EL_PIXMAP_IMP_WIDGET which allows
			-- drawing operations on the pixmap and
			-- display on the screen.
		local
			widget_pixmap: EL_PIXMAP_IMP_WIDGET
		do
			if not is_destroyed then
				create widget_pixmap.make_with_simple (Current)
				attached_interface.replace_implementation (widget_pixmap)

					-- Discard current implementation
				safe_destroy
			end
		end

feature {NONE} -- Implementation

	effective_load_file
		local
			l_path: FILE_PATH; bitmap: WEL_GDIP_BITMAP
		do
			l_path := pixmap_filename
			if l_path.has_some_extension (Jpeg_extensions, True) and then l_path.exists then
				disable_initialized
				create bitmap.make_with_size (1, 1)
				bitmap.load_image_from_path (pixmap_filename)
				set_bitmap_and_mask (bitmap.new_bitmap, Void, bitmap.width, bitmap.height)
				set_is_initialized (True)
			else
				Precursor
			end
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Implementation

	interface: detachable EL_PIXMAP note option: stable attribute end;

feature {NONE} -- Constants

	Jpeg_extensions: ARRAY [STRING]
		once
			Result := << "jpeg", "jpg" >>
		end

end