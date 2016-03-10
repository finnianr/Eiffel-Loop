note
	description: "Summary description for {EL_IP_ADAPTER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-09 11:50:05 GMT (Tuesday 9th September 2014)"
	revision: "2"

class
	EL_IP_ADAPTER_LIST

inherit
	EL_CROSS_PLATFORM [EL_IP_ADAPTER_LIST_IMPL]
		undefine
			is_equal, copy
		end

	LINKED_LIST [EL_IP_ADAPTER]
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			make_default
			append (implementation.list)
		end

end
