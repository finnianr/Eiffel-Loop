note
	description: "Cross platform interface to list of network adapater devices"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-05 19:17:05 GMT (Wednesday 5th August 2020)"
	revision: "7"

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
