note
	description: "Summary description for {EL_VERTICAL_PIXELS_REF}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-22 16:32:37 GMT (Monday 22nd December 2014)"
	revision: "4"

class
	EL_VERTICAL_PIXELS_INTEGER_REF

inherit
	INTEGER_32_REF

	EL_MODULE_SCREEN
		undefine
			is_equal, out
		end

feature {NONE} -- Initialization

	make_with_cms (a_height_cms: DOUBLE)
		do
			set_item (Screen.horizontal_pixels (a_height_cms.truncated_to_real))
		end

end
