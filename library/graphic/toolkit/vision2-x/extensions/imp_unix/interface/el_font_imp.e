note
	description: "[
		Unix counterpart to Windows ${EL_FONT_IMP} which fixes a problem settting the height in pixels
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_FONT_IMP

inherit
	EL_FONT_I
		undefine
			set_values, string_size
		redefine
			interface
		end

	EV_FONT_IMP
		redefine
			interface, is_proportional
		end

create
	make

feature {NONE} -- Implementation

	interface: detachable EL_FONT note option: stable attribute end;

	is_proportional: BOOLEAN
		local
			l_height, width_i, width_w: INTEGER; layout: POINTER
		do
			layout :=  App_implementation.Pango_layout
			across Wide_narrow_strings as array loop
				if attached array.item as string then
					{GTK2}.pango_layout_set_text (layout, string.item, string.string_length)
					{GTK2}.pango_layout_set_font_description (layout, font_description)
					{GTK2}.pango_layout_get_pixel_size (layout, $width_i, $l_height)
					{GTK2}.pango_layout_set_font_description (layout, default_pointer)
					if array.is_first then
						width_w := width_i
					else
						Result := width_w > width_i
					end
				end
			end
		end

feature {NONE} -- Constants

	Wide_narrow_strings: ARRAY [EV_GTK_C_STRING]
		once
			Result := << "w", "i" >>
		end

end