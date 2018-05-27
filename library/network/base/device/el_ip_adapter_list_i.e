note
	description: "Ip adapter list i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_IP_ADAPTER_LIST_I

inherit
	ARRAYED_LIST [EL_IP_ADAPTER]
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