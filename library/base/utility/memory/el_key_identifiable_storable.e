note
	description: "Summary description for {EL_KEY_IDENTIFIABLE_STORABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-19 17:10:37 GMT (Sunday 19th November 2017)"
	revision: "3"

deferred class
	EL_KEY_IDENTIFIABLE_STORABLE

inherit
	EL_STORABLE

	EL_KEY_IDENTIFIABLE
		undefine
			is_equal
		end
		
end
