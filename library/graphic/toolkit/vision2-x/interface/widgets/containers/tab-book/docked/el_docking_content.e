note
	description: "Summary description for {EL_DOCKING_CONTENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "5"

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
			if tab.is_closeable then
				close_request_actions.extend (agent tab.close)
			end
			show_actions.extend (agent tab.on_show)
		end

feature -- Access

	tab: EL_DOCKED_TAB

end
