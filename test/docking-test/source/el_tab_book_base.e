note
	description: "[
		Base class for notebooks
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-20 11:48:07 GMT (Wednesday 20th February 2013)"
	revision: "2"

deferred class
	EL_TAB_BOOK_BASE

feature {NONE} -- Initialization

	init_keyboard_shortcuts (a_window: EV_WINDOW)
		do
		end

feature -- Access

	count: INTEGER
		deferred
		end

	selected_index: INTEGER
		deferred
		end

feature -- Element change

	set_selected_index (a_selected_index: INTEGER)
		require
			valid_index: valid_index (a_selected_index)
		deferred
		end

feature -- Basic operations

	select_neighbouring_tab (index_delta: INTEGER)
			-- select tab to left or right,
			-- wrapping around if gone past the first or last tab
		do
			set_selected_index ((count + index_delta + selected_index - 1) \\ count + 1)
		end

feature -- Contract Support

	valid_index (a_index: INTEGER): BOOLEAN
		deferred
		end

end
