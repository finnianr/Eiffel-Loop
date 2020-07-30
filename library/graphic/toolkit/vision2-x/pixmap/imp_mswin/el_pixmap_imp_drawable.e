note
	description: "[
		EiffelVision pixmap. MS Windows implementation for drawable pixmap (drawable, not self-displayable)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-28 14:58:42 GMT (Tuesday 28th July 2020)"
	revision: "3"

class
	EL_PIXMAP_IMP_DRAWABLE

inherit
	EV_PIXMAP_IMP_DRAWABLE
		redefine
			interface,
			promote_to_widget
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
	make_with_simple, make_with_pixel_buffer

feature {NONE} -- Initialization

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		do
		end

feature {NONE} -- Implementation

	promote_to_widget
		local
			widget_pixmap: EL_PIXMAP_IMP_WIDGET
		do
			create widget_pixmap.make_with_drawable (Current)
			attached_interface.replace_implementation (widget_pixmap)
		end

feature {EV_ANY, EV_ANY_I}

	interface: EL_PIXMAP
		note
			option: stable
		attribute
		end

end -- class EL_PIXMAP_IMP_DRAWABLE


