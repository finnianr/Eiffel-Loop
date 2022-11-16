note
	description: "Unix implementation of [$source EL_STOCK_COLORS_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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