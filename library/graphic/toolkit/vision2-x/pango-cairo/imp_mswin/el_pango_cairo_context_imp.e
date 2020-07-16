note
	description: "Windows implementation of [$source EL_PANGO_CAIRO_CONTEXT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 10:04:36 GMT (Monday 13th July 2020)"
	revision: "3"

class
	EL_PANGO_CAIRO_CONTEXT_IMP

inherit
	EL_PANGO_CAIRO_CONTEXT_I

	EL_MODULE_SYSTEM_FONTS

create
	make

feature {NONE} -- Implementation

	check_font_availability
		local
			substitute_fonts: like System_fonts.Substitute_fonts
		do
			substitute_fonts := System_fonts.Substitute_fonts
			substitute_fonts.search (font.name)
			if substitute_fonts.found then
				font.preferred_families.start
				font.preferred_families.replace (substitute_fonts.found_item.to_string_32)
			end
		end

	set_source_color
		do
			Cairo.set_source_rgba (context, color.red, color.green, color.blue, 1.0)
		end

end