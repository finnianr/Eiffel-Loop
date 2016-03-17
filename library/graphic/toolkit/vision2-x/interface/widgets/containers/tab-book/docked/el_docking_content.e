note
	description: "Summary description for {EL_DOCKING_CONTENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-08-31 8:46:40 GMT (Monday 31st August 2015)"
	revision: "7"

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
			close_request_actions.extend (agent tab.close)
			focus_in_actions.extend (agent tab.on_focus_in)
		end

feature -- Access

	tab: EL_DOCKED_TAB

end
