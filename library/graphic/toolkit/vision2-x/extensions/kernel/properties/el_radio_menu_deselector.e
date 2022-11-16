note
	description: "Helper class to deselect radio items"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

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