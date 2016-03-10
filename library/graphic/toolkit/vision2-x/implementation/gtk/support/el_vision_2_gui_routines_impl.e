note
	description: "Summary description for {EL_VISION_2_GUI_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_VISION_2_GUI_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

feature -- Access

	Text_field_background_color: EV_COLOR
			--
		once
			Result := (create {EV_TEXT_FIELD}).background_color
		end
end
