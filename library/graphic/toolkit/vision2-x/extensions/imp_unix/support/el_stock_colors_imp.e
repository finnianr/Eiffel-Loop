note
	description: "Unix implementation of [$source EL_STOCK_COLORS_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-11 15:00:35 GMT (Friday 11th September 2020)"
	revision: "5"

class
	EL_STOCK_COLORS_IMP

inherit
	EL_STOCK_COLORS_I

	EL_OS_IMPLEMENTATION

feature -- Access

	Text_field_background: EV_COLOR
			--
		once
			Result := (create {EV_TEXT_FIELD}).background_color
		end
end
