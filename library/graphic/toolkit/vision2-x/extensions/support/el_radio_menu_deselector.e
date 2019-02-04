note
	description: "Helper class to deselect radio items"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
