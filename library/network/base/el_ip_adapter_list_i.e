note
	description: "Summary description for {EL_IP_ADAPTER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-06 12:26:47 GMT (Monday 6th June 2016)"
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
