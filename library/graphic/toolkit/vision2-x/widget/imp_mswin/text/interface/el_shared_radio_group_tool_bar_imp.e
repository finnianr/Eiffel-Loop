note
	description: "Shared radio group tool bar imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_SHARED_RADIO_GROUP_TOOL_BAR_IMP

inherit
	EL_SHARED_RADIO_GROUP_TOOL_BAR_I
		redefine
			interface
		end

	EV_TOOL_BAR_IMP
		redefine
			interface, make
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			Precursor {EV_TOOL_BAR_IMP}
			radio_group := interface.radio_group
		end

feature {EV_ANY_I} -- Implementation

	interface: EL_SHARED_RADIO_GROUP_TOOL_BAR

end