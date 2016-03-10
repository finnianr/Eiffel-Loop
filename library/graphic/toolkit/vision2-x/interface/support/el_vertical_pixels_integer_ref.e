note
	description: "Summary description for {EL_VERTICAL_PIXELS_REF}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-08 13:25:17 GMT (Friday 8th March 2013)"
	revision: "2"

class
	EL_VERTICAL_PIXELS_INTEGER_REF

inherit
	INTEGER_32_REF

	EL_MODULE_GRAPHICS_SYSTEM
		undefine
			is_equal, out
		end

feature {NONE} -- Initialization

	make_with_cms (a_height_cms: DOUBLE)
		do
			set_item (Graphics_system.centimeter_pixels_y (a_height_cms.truncated_to_real))
		end

end
