note
	description: "Changes pointer style to a hand icon when pointer enters widget"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_HAND_STYLE_POINTER_ACTION

inherit
	EV_WIDGET_ACTION_SEQUENCES

	EL_SHARED_DEFAULT_PIXMAPS

feature {NONE} -- Initialization

	initialize
		do
			pointer_enter_actions.extend (agent on_enter)
			pointer_leave_actions.extend (agent on_leave)
		end

feature {NONE} -- Event handling

	on_enter
		do
			if is_sensitive then
				set_pointer_style (Style.Hyperlink_cursor)
			end
		end

	on_leave
		do
			if is_sensitive then
				set_pointer_style (Style.Standard_cursor)
			end
		end

feature {NONE} -- Implementation

	is_sensitive: BOOLEAN
		deferred
		end

	set_pointer_style (a_cursor: EV_POINTER_STYLE)
		deferred
		end

	style: EL_STOCK_PIXMAPS
		do
			Result := Default_pixmaps
		end

end