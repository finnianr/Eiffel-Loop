note
	description: "Unix implementation of ${EL_STOCK_COLORS_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_STOCK_COLORS_IMP

inherit
	EL_STOCK_COLORS_I

	EL_UNIX_IMPLEMENTATION

feature -- Access

	Text_field_background: EV_COLOR
			--
		once
			Result := (create {EV_TEXT_FIELD}).background_color
		end
end