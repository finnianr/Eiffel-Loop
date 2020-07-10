note
	description: "Pixmap imp widget"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-03 13:14:59 GMT (Friday 3rd July 2020)"
	revision: "2"

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

	EL_PIXMAP_TO_JPEG_IMP

create 
	make_with_simple,
	make_with_drawable

feature {EV_ANY, EV_ANY_I} 

	interface: EL_PIXMAP
		note
			option: stable
		attribute
		end
	
end -- class EL_PIXMAP_IMP_WIDGET


