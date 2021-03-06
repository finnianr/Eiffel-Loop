note
	description: "Pixmap widget implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:26:04 GMT (Sunday 2nd August 2020)"
	revision: "5"

class
	EL_PIXMAP_IMP_WIDGET

inherit
	EV_PIXMAP_IMP_WIDGET
		redefine
			interface
		end

	EL_PIXMAP_I
		undefine
			flush,
			save_to_named_path,
			on_orphaned,
			on_parented,
			set_pebble,
			set_actual_drop_target_agent,
			set_pebble_function,
			draw_straight_line,
			disable_initialized
		redefine
			interface
		end

create
	make_with_simple, make_with_drawable

feature {NONE} -- Initialization

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		do
		end

	init_from_buffer (drawing: CAIRO_DRAWING_AREA)
			-- Initialize from `drawing'
		do
		end

feature {EV_ANY, EV_ANY_I} -- Internal attributes

	interface: EL_PIXMAP
		note
			option: stable
		attribute
		end

end -- class EL_PIXMAP_IMP_WIDGET


