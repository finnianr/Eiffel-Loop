note
	description: "Button that changes pointer style to a hand icon"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-15 10:54:58 GMT (Wednesday 15th July 2020)"
	revision: "1"

deferred class
	EL_HAND_POINTER_BUTTON

inherit
	EL_MODULE_PIXMAP
		rename
			Pixmap as Style
		end

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

	pointer_enter_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer enters widget.
		deferred
		end

	pointer_leave_actions: EV_NOTIFY_ACTION_SEQUENCE
			-- Actions to be performed when screen pointer leaves widget.
		deferred
		end

	set_pointer_style (a_cursor: EV_POINTER_STYLE)
		deferred
		end

end
