note
	description: "[
		Warning: this implementation was originally written for Windows and may not work on GTK
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_SHARED_RADIO_GROUP_TOOL_BAR_IMP

inherit
	EL_SHARED_RADIO_GROUP_TOOL_BAR_I
		redefine
			interface
		end

	EV_TOOL_BAR_IMP
		redefine
			interface
		end

create
	make

feature {EV_ANY_I} -- Implementation

	interface: EL_SHARED_RADIO_GROUP_TOOL_BAR

end