note
	description: "[
		EiffelVision pixmap. MS Windows implementation for drawable pixmap (drawable, not self-displayable)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-03 13:14:08 GMT (Friday 3rd July 2020)"
	revision: "2"

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

	make_scaled_to_size (other: EV_PIXMAP; dimension: NATURAL_8; size: INTEGER)
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


