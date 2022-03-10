note
	description: "Docking content"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-10 6:49:12 GMT (Thursday 10th March 2022)"
	revision: "6"

class
	EL_DOCKING_CONTENT

inherit
	SD_CONTENT

create
	make_with_tab

feature {NONE} -- Initialization

	make_with_tab (a_tab: like tab)
		do
			tab := a_tab
			make_with_widget (tab.content_border_box, tab.unique_title)
			close_request_actions.extend (agent on_close_request)
			focus_in_actions.extend (agent on_focus_in)
		end

feature -- Access

	tab: EL_DOCKED_TAB

feature -- Element change

	set_tab (a_tab: EL_DOCKED_TAB)
		do
			tab := a_tab
		end

feature {NONE} -- Event handling

	on_close_request
		do
			tab.close
		end

	on_focus_in
		do
			tab.on_focus_in
		end

end