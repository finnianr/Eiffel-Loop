note
	description: "Ip adapter list i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-27 15:12:54 GMT (Friday 27th December 2019)"
	revision: "6"

deferred class
	EL_IP_ADAPTER_LIST_I

inherit
	EL_ARRAYED_LIST [EL_IP_ADAPTER]
		rename
			make as make_list
		end

feature {NONE} -- Initialization

	make
		do
			make_list (3)
			initialize
		end

	initialize
		deferred
		end

end
