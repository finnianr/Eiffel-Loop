note
	description: "Summary description for {EL_VISION_2_GUI_ROUTINES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-24 10:34:43 GMT (Wednesday 24th June 2015)"
	revision: "3"

class
	EL_VISION_2_GUI_ROUTINES_IMPL

inherit
	EL_PLATFORM_IMPL

create
	make
	
feature -- Access

	Text_field_background_color: EV_COLOR
			--
		once
			Result := (create {EV_TEXT_FIELD}).background_color
		end
end
