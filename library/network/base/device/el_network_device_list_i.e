note
	description: "Cross platform interface to list of network adapater devices"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	EL_NETWORK_DEVICE_LIST_I

inherit
	EL_ARRAYED_LIST [EL_NETWORK_DEVICE_I]
		rename
			make as make_list
		end

feature {NONE} -- Initialization

	make
		deferred
		end

end