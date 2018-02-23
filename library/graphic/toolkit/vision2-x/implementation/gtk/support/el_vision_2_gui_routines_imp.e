note
	description: "Unix implementation of [$source EL_VISION_2_GUI_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_VISION_2_GUI_ROUTINES_IMP

inherit
	EL_VISION_2_GUI_ROUTINES_I

	EL_OS_IMPLEMENTATION

create
	make

feature -- Access

	Text_field_background_color: EV_COLOR
			--
		once
			Result := (create {EV_TEXT_FIELD}).background_color
		end
end
