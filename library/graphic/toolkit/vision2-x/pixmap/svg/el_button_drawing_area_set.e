note
	description: "Set of ${CAIRO_DRAWING_AREA} objects for class ${EL_DRAWING_AREA_BUTTON}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "15"

class
	EL_BUTTON_DRAWING_AREA_SET

inherit
	ARRAY [CAIRO_DRAWING_AREA]
		rename
			make as make_array,
			item as drawing_area,
			valid_index as valid_state
		export
			{NONE} all
			{ANY} drawing_area, valid_state
		redefine
			default_create
		end

	EL_SHARED_BUTTON_STATE

create
	make, default_create

convert
	make ({EL_SVG_BUTTON_PIXMAP_SET, EL_SVG_TEMPLATE_BUTTON_PIXMAP_SET})

feature {NONE} -- Initialization

	default_create
		do
			make_filled (Default_item, 1, Button_state.count)
		end

	make (a_set: EL_SVG_BUTTON_PIXMAP_SET)
		do
			default_create
			across Button_state.list as state loop
				put (a_set.drawing_area (state.item), state.item.to_integer_32)
			end
		end

feature {NONE} -- Constants

	Default_item: CAIRO_DRAWING_AREA
		once
			create Result
		end

end