note
	description: "Windows implementation of [$source CAIRO_TEXT_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-04 10:28:58 GMT (Tuesday 4th August 2020)"
	revision: "2"

class
	CAIRO_TEXT_LAYOUT_IMP

inherit
	CAIRO_TEXT_LAYOUT_I

	EL_OS_IMPLEMENTATION

	EL_MODULE_SYSTEM_FONTS

create
	make

feature {NONE} -- Implementation

	update_preferred_families
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

end
