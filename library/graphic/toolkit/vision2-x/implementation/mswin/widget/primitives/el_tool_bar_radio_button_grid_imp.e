note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TOOL_BAR_RADIO_BUTTON_GRID_IMP

inherit
	EL_TOOL_BAR_RADIO_BUTTON_GRID_I
		redefine
			interface
		end

	EV_VERTICAL_BOX_IMP
		rename
			radio_group as radio_button_group
		redefine
			interface, make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create radio_group.make
		end

feature {EL_SHARED_RADIO_GROUP_TOOL_BAR_IMP} -- Implementation

	radio_group: LINKED_LIST [EV_TOOL_BAR_RADIO_BUTTON_IMP]

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: EL_TOOL_BAR_RADIO_BUTTON_GRID

end
