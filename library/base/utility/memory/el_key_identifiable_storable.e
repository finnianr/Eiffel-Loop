note
	description: "Summary description for {EL_KEY_IDENTIFIABLE_STORABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-14 12:53:29 GMT (Thursday 14th May 2015)"
	revision: "6"

deferred class
	EL_KEY_IDENTIFIABLE_STORABLE

inherit
	EL_STORABLE

	EL_KEY_IDENTIFIABLE
		undefine
			is_equal
		end
end
