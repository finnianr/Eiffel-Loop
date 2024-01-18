note
	description: "Unix implementation of ${EL_STOCK_COLORS_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:55:32 GMT (Sunday 5th November 2023)"
	revision: "7"

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