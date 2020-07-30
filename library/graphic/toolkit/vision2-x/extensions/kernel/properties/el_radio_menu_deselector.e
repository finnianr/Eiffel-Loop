note
	description: "Helper class to deselect radio items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 9:30:39 GMT (Thursday 16th July 2020)"
	revision: "2"

class
	EL_RADIO_MENU_DESELECTOR

inherit
	EV_ANY_I

feature -- Basic operations

	deselect (radio: EV_RADIO_MENU_ITEM)
		do
			if attached {EV_RADIO_MENU_ITEM_IMP} radio.implementation as imp then
				imp.disable_select
			end
		end

feature {NONE} -- Implementation

	make
		do
		end

	old_make (an_interface: like interface)
		do
		end

	destroy
		do
		end

end
