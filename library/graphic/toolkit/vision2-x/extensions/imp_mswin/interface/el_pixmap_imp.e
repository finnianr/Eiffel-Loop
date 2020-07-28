note
	description: "Windows implemenation of interface [$source EL_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-14 14:30:57 GMT (Tuesday 14th July 2020)"
	revision: "5"

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

	EL_PIXMAP_TO_JPEG_IMP

create
	make

feature {NONE} -- Initialization

	make_scaled_to_size (other: EV_PIXMAP; dimension: NATURAL_8; size: INTEGER)
		local
			src_bitmap, dest_bitmap: WEL_GDIP_BITMAP; area: EL_RECTANGLE
			graphics: WEL_GDIP_GRAPHICS; dest_rect, source_rect: WEL_RECT
		do
			create area.make_scaled_for_widget (dimension, other, size)
			create dest_bitmap.make_with_size (area.width, area.height)

			if attached {EV_PIXMAP_IMP} other.implementation as imp_other then
				create src_bitmap.make_from_bitmap (imp_other.get_bitmap, imp_other.palette)
				create graphics.make_from_image (dest_bitmap)

				create source_rect.make (0, 0, other.width, other.height)
				create dest_rect.make (0, 0, area.width, area.height)

				graphics.draw_image_with_dest_rect_src_rect (src_bitmap, dest_rect, source_rect)

				dest_rect.dispose; source_rect.dispose
				graphics.destroy_item

				set_bitmap_and_mask (dest_bitmap.new_bitmap, Void, dest_bitmap.width, dest_bitmap.height)
				check
					dimensions_match: height = area.height and width = area.width
				end
				set_is_initialized (True)
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
			l_path: EL_FILE_PATH; bitmap: WEL_GDIP_BITMAP
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
